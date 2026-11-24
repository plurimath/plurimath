# frozen_string_literal: true

module Plurimath
  # Strict Content MathML input (plurimath#35). The text is read by the
  # openmath gem into its OpenMath object model; this class maps the part of
  # that model Plurimath can write (arith1 plus/times/minus/unary_minus/
  # divide/power over integers and variables) to a Formula. Anything else is
  # refused instead of being guessed at.
  class ContentMathml
    # A well-formed OpenMath/Content MathML object that Plurimath has no
    # Formula form for.
    class UnsupportedError < StandardError; end

    SUM_LEVEL = 1
    PRODUCT_LEVEL = 2
    ATOM_LEVEL = 4

    attr_accessor :text

    def initialize(text)
      @text = text
    end

    def to_formula
      require "openmath"
      object = Openmath::ContentMathML.parse(text)
      root = children(object)
      raise UnsupportedError, "expected exactly one object" unless root.size == 1

      Math::Formula.new(convert(root.first).first)
    end

    private

    def children(container)
      cursors = Hash.new(0)
      container.element_order.filter_map do |element|
        attribute = Openmath::Evaluation::Evaluator::CHILD_ATTRIBUTES[element.name]
        next unless attribute

        index = cursors[element.name]
        cursors[element.name] += 1
        container.public_send(attribute)[index]
      end
    end

    # Returns [nodes, binding level].
    def convert(node)
      case node.class.name.split("::").last
      when "Omi" then [[Math::Number.new(node.value.join.strip)], ATOM_LEVEL]
      when "Omv" then [[Math::Symbols::Symbol.new(node.name)], ATOM_LEVEL]
      when "Oma" then application(node)
      else
        raise UnsupportedError,
              "#{node.class.name.split('::').last} has no Plurimath form"
      end
    end

    def application(node)
      head, *arguments = children(node)
      unless head.class.name.split("::").last == "Oms"
        raise UnsupportedError, "application head is not a symbol"
      end

      key = "#{head.cd}/#{head.name}"
      case key
      when "arith1/plus" then nary(arguments, Math::Symbols::Plus, SUM_LEVEL, key)
      when "arith1/times" then nary(arguments, Math::Symbols::Cdot, PRODUCT_LEVEL, key)
      when "arith1/minus" then minus(arguments)
      when "arith1/unary_minus" then unary_minus(arguments)
      when "arith1/divide" then divide(arguments)
      when "arith1/power" then power(arguments)
      else raise UnsupportedError, "symbol #{key} has no Plurimath form"
      end
    end

    def operand(node, minimum)
      nodes, level = convert(node)
      return nodes if level >= minimum

      [fenced(nodes)]
    end

    def fenced(nodes)
      Math::Function::Fenced.new(
        Math::Symbols::Paren::Lround.new,
        nodes,
        Math::Symbols::Paren::Rround.new,
      )
    end

    def arity!(arguments, count, key)
      return if arguments.size == count

      raise UnsupportedError, "#{key} needs #{count} arguments, got #{arguments.size}"
    end

    def nary(arguments, operator, level, key)
      raise UnsupportedError, "#{key} needs at least two arguments" if arguments.size < 2

      nodes = arguments.each_with_index.flat_map do |argument, index|
        [(operator.new unless index.zero?), *operand(argument, level + 1)].compact
      end
      [nodes, level]
    end

    def minus(arguments)
      arity!(arguments, 2, "arith1/minus")
      left = operand(arguments[0], SUM_LEVEL)
      right = operand(arguments[1], PRODUCT_LEVEL)
      [[*left, Math::Symbols::Minus.new, *right], SUM_LEVEL]
    end

    def unary_minus(arguments)
      arity!(arguments, 1, "arith1/unary_minus")
      [[Math::Symbols::Minus.new, *operand(arguments[0], PRODUCT_LEVEL)], SUM_LEVEL]
    end

    def divide(arguments)
      arity!(arguments, 2, "arith1/divide")
      numerator, denominator = arguments.map { |argument| group(convert(argument).first) }
      [[Math::Function::Frac.new(numerator, denominator)], ATOM_LEVEL]
    end

    def power(arguments)
      arity!(arguments, 2, "arith1/power")
      base = group(operand(arguments[0], ATOM_LEVEL))
      exponent = group(convert(arguments[1]).first)
      [[Math::Function::Power.new(base, exponent)], ATOM_LEVEL]
    end

    def group(nodes)
      nodes.one? ? nodes.first : Math::Formula.new(nodes)
    end
  end
end
