# frozen_string_literal: true

require "cgi"

module Plurimath
  class Openmath
    # Uses the shared precedence parser; unsupported semantics refuse explicitly.
    class Writer
      RELATIONS = {
        "=" => "eq", "<" => "lt", ">" => "gt", "≤" => "leq",
        "≥" => "geq", "≠" => "neq", "<=" => "leq", ">=" => "geq", "!=" => "neq"
      }.freeze

      def serialize(formula, version: 2)
        raise ArgumentError, "unsupported OpenMath version #{version.inspect}" unless [2, 3].include?(version)

        if formula.openmath_source_current?
          object = ::Openmath.parse(formula.openmath_source.to_xml, version: version)
          object.version = "#{version}.0"
          return validated_xml(object.to_xml, version)
        end

        xml = %(<OMOBJ xmlns="http://www.openmath.org/OpenMath" version="#{version}.0">#{evaluate_node(formula)}</OMOBJ>)
        validated_xml(xml, version)
        ::Openmath.parse(xml, version: version).to_xml
      end

      def evaluate_node(node)
        case node
        when Math::Formula
          Math::Evaluation::ExpressionParser.new(self, node.value).parse
        when Array
          Math::Evaluation::ExpressionParser.new(self, node).parse
        when Math::Number
          number(node)
        when Semantic
          node.value
        when Symbol
          base = node.cdbase ? %( cdbase="#{escape(node.cdbase)}") : ""
          %(<OMS cd="#{escape(node.cd)}" name="#{escape(node.value)}"#{base}/>)
        when Math::Symbols::Pi
          '<OMS cd="nums1" name="pi"/>'
        when Math::Symbols::Symbol
          unsupported(node) unless node.instance_of?(Math::Symbols::Symbol)
          name = Utility.html_entity_to_unicode(node.value.to_s)
          unsupported(node) if node.operator? || !name.match?(/\A\p{L}[\p{L}\p{N}_]*\z/)
          %(<OMV name="#{escape(name)}"/>)
        when Math::Function::Frac
          unsupported(node) if node.options&.key?(:choose)
          divide(evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Math::Function::Power
          power(evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when *Converter::UNARY_FUNCTIONS.values
          cd, name = Converter::UNARY_FUNCTIONS.key(node.class).to_s.split("/")
          unsupported(node) unless name
          application(cd, name, evaluate_node(node.parameter_one))
        when Math::Function::Max, Math::Function::Min
          function_arguments(node)
        when Math::Function::Text
          unsupported(node) unless node.parameter_one.is_a?(String)
          "<OMSTR>#{escape(node.parameter_one)}</OMSTR>"
        when Math::Function::Fenced
          unless node.parameter_one.is_a?(Math::Symbols::Paren::Lround) &&
              node.parameter_three.is_a?(Math::Symbols::Paren::Rround)
            unsupported(node)
          end
          evaluate_node(node.parameter_two)
        else
          unsupported(node)
        end
      end

      def normalize_tokens(tokens)
        tokens
      end

      def relation_operator?(node)
        node.is_a?(Math::Symbols::Symbol) && RELATIONS.key?(glyph(node))
      end

      # logic1 connectives are evaluator-only; display backends treat the
      # operators as ordinary unsupported tokens.
      def logic_operator?(_node)
        false
      end

      def negation?(_node)
        false
      end

      def connective(_node)
        nil
      end

      def evaluate_operand(node)
        evaluate_node(node)
      end

      def relation(operator, left, right)
        unsupported("chained relations") if left.start_with?('<OMA><OMS cd="relation1"')
        application("relation1", RELATIONS.fetch(glyph(operator)), left, right)
      end

      def add(left, right)
        application("arith1", "plus", left, right)
      end

      def subtract(left, right)
        application("arith1", "minus", left, right)
      end

      def multiply(left, right, **_options)
        # ExpressionParser supplies the spelling; OpenMath times is explicit.
        application("arith1", "times", left, right)
      end

      def divide(left, right)
        application("arith1", "divided_by", left, right)
      end

      def power(left, right)
        application("arith1", "power", left, right)
      end

      def negate(value)
        application("arith1", "unary_minus", value)
      end

      def positive(value)
        value
      end
      alias group positive

      def nary_function?(_node)
        false
      end

      def log_argument(node, _argument)
        unsupported(node)
      end

      def negated_mod(node)
        unsupported(node)
      end

      def unsupported(node)
        raise UnsupportedError.new(node.is_a?(String) ? node : node.class.name, :openmath)
      end

      private

      def validated_xml(xml, version)
        ::Openmath.validate!(xml, version: version)
        xml
      rescue ::Openmath::Validation::ValidationError => e
        raise UnsupportedError.new(e.message, :openmath)
      end

      def function_arguments(node)
        tokens = node.parameter_one
        tokens = tokens.value if tokens.is_a?(Math::Formula)
        tokens = tokens.parameter_two if tokens.is_a?(Math::Function::Fenced)
        arguments = [[]]
        Array(tokens).each do |token|
          if token.is_a?(Math::Symbols::Comma)
            arguments << []
          else
            arguments.last << token
          end
        end
        unsupported(node) if arguments.any?(&:empty?)
        application("arith1", node.is_a?(Math::Function::Max) ? "max" : "min",
                    *arguments.map { |argument| evaluate_node(argument) })
      end

      def application(dictionary, name, *operands)
        %(<OMA><OMS cd="#{dictionary}" name="#{name}"/>#{operands.join}</OMA>)
      end

      def escape(value)
        CGI.escapeHTML(value.to_s)
      end

      def glyph(node)
        Utility.html_entity_to_unicode(node.value.to_s)
      end

      def number(node)
        unsupported(node) unless node.base.nil? || node.base == 10

        value = node.value.to_s
        return "<OMI>#{escape(value)}</OMI>" if value.match?(/\A[+-]?\d+\z/)
        return %(<OMF dec="#{escape(value)}"/>) if value.match?(/\A[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?\z/)

        unsupported(node)
      end
    end
  end
end
