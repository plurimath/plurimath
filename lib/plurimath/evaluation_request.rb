# frozen_string_literal: true

require "json"
require_relative "../plurimath"

module Plurimath
  # A closed numeric AST profile over the existing evaluator. Quantity budgets,
  # registers and GUM requests are separate profiles, never silently discarded.
  module EvaluationRequest
    SCHEMA = "plurimath.evaluate.numeric/1"
    ENGINE = "plurimath.numeric/1"
    GRAMMAR = "plurimath.numeric-ast/1"
    DECIMAL = /\A[+-]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE][+-]?[0-9]+)?\z/
    NAME = /\A[A-Za-z_][A-Za-z0-9_]*\z/
    FUNCTIONS = {"sqrt" => Math::Function::Sqrt, "sin" => Math::Function::Sin,
                 "cos" => Math::Function::Cos, "exp" => Math::Function::Exp,
                 "ln" => Math::Function::Ln, "abs" => Math::Function::Abs}.freeze
    ERRORS = %w[DivisionByZeroError MathDomainError MissingVariableError
                NonFiniteResultError UnsupportedExpressionError
                InvalidBindingError InvalidBindingKeyError].freeze

    class InvalidRequest < StandardError; end

    module_function

    def call(json)
      invalid! unless json.is_a?(String)
      request = JSON.parse(json)
      keys!(request, %w[schema ast bindings mode guard_digits], %w[schema ast])
      invalid! unless request["schema"] == SCHEMA
      mode = request.fetch("mode", "strict")
      invalid! unless %w[strict approximate].include?(mode)
      digits = request["guard_digits"]
      invalid! unless digits.nil? || ((digits.is_a?(Integer) || digits.is_a?(Float)) && digits.finite? && digits.positive? && digits <= 1000 && digits == digits.to_i)
      digits = digits.to_i unless digits.nil?
      bindings = request.fetch("bindings", {})
      invalid! unless bindings.is_a?(Hash)
      bindings.each { |name, value| invalid! unless name.match?(NAME) && decimal?(value) }
      document = formula(request.fetch("ast"))
      # Explicit mode and a closed AST without iteration avoid configuration
      # defaults. No textual parser, unit register, filesystem or ENV lookup.
      result = Math::Evaluation::Evaluator.new(document, bindings, mode: mode.to_sym,
                                               guard_digits: digits, unevaluated: [request["ast"]]).evaluate
      response = envelope.merge("ok" => true, "result" => {
        "value" => numeric(result.value),
        "boundaries" => result.boundaries.map { |boundary| encode_boundary(boundary) },
        "deferred" => result.deferred?,
      })
      response["result"]["unevaluated_ast"] = request["ast"] if result.deferred?
      canonical(response)
    rescue JSON::ParserError, InvalidRequest
      canonical(envelope.merge("ok" => false, "error" => {"code" => "InvalidRequest"}))
    rescue Plurimath::Errors::Evaluation::Error => error
      code = error.class.name.split("::").last
      raise unless ERRORS.include?(code)

      canonical(envelope.merge("ok" => false, "error" => {"code" => code}))
    end

    def formula(ast)
      node = build(ast, 0)
      node.is_a?(Math::Formula) ? node : Math::Formula.new([node])
    end

    def build(ast, depth)
      invalid! if depth > 64
      invalid! unless ast.is_a?(Hash)
      case ast["type"]
      when "number"
        keys!(ast, %w[type text], %w[type text])
        invalid! unless decimal?(ast["text"])
        Math::Number.new(ast["text"])
      when "variable"
        keys!(ast, %w[type name], %w[type name])
        invalid! unless ast["name"].is_a?(String) && ast["name"].match?(NAME)
        Math::Symbols::Symbol.new(ast["name"])
      when "binary"
        keys!(ast, %w[type operator left right], %w[type operator left right])
        invalid! unless %w[+ - * / ^].include?(ast["operator"])
        left, right = build(ast["left"], depth + 1), build(ast["right"], depth + 1)
        case ast["operator"]
        when "/" then Math::Function::Frac.new(left, right)
        when "^" then Math::Function::Power.new(group(left), group(right))
        else
          klass = {"+" => Math::Symbols::Plus, "-" => Math::Symbols::Minus, "*" => Math::Symbols::Times}.fetch(ast["operator"])
          Math::Formula.new([group(left), klass.new, group(right)])
        end
      when "unary"
        keys!(ast, %w[type operator operand], %w[type operator operand])
        invalid! unless %w[+ -].include?(ast["operator"])
        Math::Formula.new([ast["operator"] == "+" ? Math::Symbols::Plus.new : Math::Symbols::Minus.new, group(build(ast["operand"], depth + 1))])
      when "call"
        keys!(ast, %w[type name argument], %w[type name argument])
        klass = FUNCTIONS[ast["name"]]
        invalid! unless klass
        klass.new(build(ast["argument"], depth + 1))
      else
        invalid!
      end
    end

    def group(node)
      return node unless node.is_a?(Math::Formula)

      Math::Formula.new([Math::Symbols::Paren::Lround.new, node, Math::Symbols::Paren::Rround.new])
    end

    def numeric(value)
      case value
      when nil then nil
      when Integer then {"kind" => "integer", "value" => value.to_s}
      when Rational then {"kind" => "rational", "numerator" => value.numerator.to_s, "denominator" => value.denominator.to_s}
      when Float then {"kind" => "float", "bits" => [value].pack("G").unpack1("H*")}
      when BigDecimal then {"kind" => "decimal", "value" => value.to_s, "precision" => value.precision}
      when String then {"kind" => "literal", "text" => value}
      else raise TypeError, "unsupported evaluator result #{value.class}"
      end
    end

    def encode_boundary(boundary)
      {"operation" => boundary.fetch(:operation),
       "operands" => boundary.fetch(:operands).map { |value| numeric(value) },
       "operand_accuracy" => boundary.fetch(:operand_accuracy).to_s,
       "action" => boundary.fetch(:action).to_s,
       "result" => numeric(boundary[:result])}
    end

    def envelope
      {"schema" => SCHEMA, "engine" => ENGINE, "grammar" => GRAMMAR}
    end

    def canonical(value)
      ordered = lambda do |item|
        case item
        when Hash then item.keys.sort.to_h { |key| [key, ordered.call(item[key])] }
        when Array then item.map { |child| ordered.call(child) }
        else item
        end
      end
      JSON.generate(ordered.call(value))
    end

    def keys!(object, allowed, required)
      invalid! unless object.is_a?(Hash) && (object.keys - allowed).empty? && (required - object.keys).empty?
    end

    def decimal?(value)
      value.is_a?(String) && value.match?(DECIMAL)
    end

    def invalid!
      raise InvalidRequest
    end
  end
end
