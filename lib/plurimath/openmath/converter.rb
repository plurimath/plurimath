# frozen_string_literal: true

module Plurimath
  class Openmath
    # The OpenMath object tree → Formula conversion for the bound core: the
    # content-dictionary symbols the evaluator also binds (nums1, arith1,
    # relation1, logic1). Literals, variables and applications convert to
    # the Formula node sequence the other notations produce; a symbol
    # outside the table refuses — nothing loses meaning silently.
    class Converter
      # application symbol → [plurimath infix symbol class, function class]
      APPLICATIONS = {
        "arith1/plus"       => Math::Symbols::Plus,
        "arith1/times"      => Math::Symbols::Cdot,
        "arith1/minus"      => Math::Symbols::Minus,
        "arith1/unary_minus" => Math::Symbols::Minus,
        "arith1/divided_by" => Math::Symbols::Slash,
        "arith1/power"      => nil, # Function::Power, handled structurally
        "arith1/abs"        => nil, # Function::Abs
        "arith1/max"        => Math::Function::Max,
        "arith1/min"        => Math::Function::Min,
        "relation1/eq"      => Math::Symbols::Equal,
        "relation1/neq"     => Math::Symbols::Ne,
        "relation1/gt"      => Math::Symbols::Greater,
        "relation1/lt"      => Math::Symbols::Less,
        "relation1/geq"     => Math::Symbols::Geq,
        "relation1/leq"     => Math::Symbols::Leq,
      }.freeze

      attr_reader :object

      def initialize(object)
        @object = object
      end

      def to_formula
        formula = convert(object)
        formula = Math::Formula.new([formula]) unless formula.is_a?(Math::Formula)
        formula
      end

      def convert(node)
        case node
        when ::Openmath::V2::Omobj, ::Openmath::V3::Omobj
          children = ::Openmath::Evaluation::Evaluator.ordered_children(node)
          raise Parse::ParseError.new(@object.to_s, :openmath) if children.empty?

          convert(children.first)
        when ::Openmath::V2::Omi, ::Openmath::V3::Omi
          Math::Number.new(node.value.join.strip.delete(" "))
        when ::Openmath::V2::Omf, ::Openmath::V3::Omf
          Math::Number.new(node.dec || node.hex)
        when ::Openmath::V2::Omv, ::Openmath::V3::Omv
          Math::Symbols::Symbol.new(node.name)
        when ::Openmath::V2::Omstr, ::Openmath::V3::Omstr
          Math::Function::Text.new(node.value.join)
        when ::Openmath::V2::Oma, ::Openmath::V3::Oma
          application(node)
        when ::Openmath::V2::Ome, ::Openmath::V3::Ome
          error(node)
        else
          raise Parse::ParseError.new(node.class.name, :openmath)
        end
      end

      private

      def application(node)
        children = ::Openmath::Evaluation::Evaluator.ordered_children(node)
        operator = children.first
        unless operator.is_a?(::Openmath::V2::Oms) || operator.is_a?(::Openmath::V3::Oms)
          raise Parse::ParseError.new(node.to_s, :openmath)
        end

        key = "#{operator.cd}/#{operator.name}"
        infix = APPLICATIONS[key]
        if infix
          operands = children[1..].map { |child| convert(child) }
          raise Parse::ParseError.new(key, :openmath) if operands.empty?

          operands.inject do |left, right|
            Math::Formula.new([left, infix.new, right])
          end
        elsif key == "arith1/power"
          Math::Function::Power.new(convert(children[1]), convert(children[2]))
        elsif key == "arith1/abs"
          Math::Function::Abs.new(convert(children[1]))
        else
          raise Parse::ParseError.new(key, :openmath)
        end
      end

      def error(node)
        symbol = ::Openmath::Evaluation::Evaluator.ordered_children(node).first
        text = symbol ? "#{symbol.cd}##{symbol.name}" : "error"
        Math::Function::Text.new(text)
      end
    end
  end
end
