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
        "arith1/plus" => Math::Symbols::Plus,
        "arith1/times" => Math::Symbols::Cdot,
        "arith1/minus" => Math::Symbols::Minus,
        "arith1/unary_minus" => Math::Symbols::Minus,
        "arith1/divided_by" => Math::Symbols::Slash,
        "arith1/power" => nil, # Function::Power, handled structurally
        "arith1/abs" => nil, # Function::Abs
        "arith1/max" => Math::Function::Max,
        "arith1/min" => Math::Function::Min,
        "relation1/eq" => Math::Symbols::Equal,
        "relation1/neq" => Math::Symbols::Ne,
        "relation1/gt" => Math::Symbols::Greater,
        "relation1/lt" => Math::Symbols::Less,
        "relation1/geq" => Math::Symbols::Geq,
        "relation1/leq" => Math::Symbols::Leq,
        "logic1/and" => Math::Symbols::Land,
        "logic1/or" => Math::Symbols::Lor,
        "logic1/xor" => Math::Symbols::Veebar,
        "logic1/implies" => Math::Symbols::UpcaseRightarrow,
      }.freeze

      # logic1 constants: the truth values the Evaluator reads from top/bot.
      LOGIC_CONSTANTS = {
        "true" => Math::Symbols::Top,
        "false" => Math::Symbols::Bot,
      }.freeze

      UNARY_FUNCTIONS = {
        "arith1/abs" => Math::Function::Abs,
        "rounding1/floor" => Math::Function::Floor,
        "rounding1/ceiling" => Math::Function::Ceil,
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
        if node.respond_to?(:cdbase) && node.cdbase &&
            node.cdbase.delete_suffix("/") != "http://www.openmath.org/cd" &&
            !node.is_a?(::Openmath::V2::Oms) && !node.is_a?(::Openmath::V3::Oms)
          raise UnsupportedError.new("inherited cdbase", :openmath)
        end

        case node
        when ::Openmath::V2::Omobj, ::Openmath::V3::Omobj
          children = ::Openmath::Evaluation::Evaluator.ordered_children(node)
          raise UnsupportedError.new(@object.to_s, :openmath) unless children.size == 1

          convert(children.first)
        when ::Openmath::V2::Omi, ::Openmath::V3::Omi
          value = node.value.join.strip.delete(" ")
          raise UnsupportedError.new(value, :openmath) unless value.match?(/\A[+-]?\d+\z/)

          Math::Number.new(value)
        when ::Openmath::V2::Omf, ::Openmath::V3::Omf
          value = float_literal(node)
          raise UnsupportedError.new(node.to_xml, :openmath) unless value.finite?

          Math::Number.new(value.to_s)
        when ::Openmath::V2::Oms, ::Openmath::V3::Oms
          standard = node.cdbase.nil? || node.cdbase.delete_suffix("/") == "http://www.openmath.org/cd"
          if node.cd == "nums1" && node.name == "pi" && standard
            Math::Symbols::Pi.new
          elsif node.cd == "logic1" && LOGIC_CONSTANTS.key?(node.name) && standard
            LOGIC_CONSTANTS.fetch(node.name).new
          else
            Symbol.new(node.name, cd: node.cd, cdbase: node.cdbase)
          end
        when ::Openmath::V2::Omv, ::Openmath::V3::Omv
          Math::Symbols::Symbol.new(node.name)
        when ::Openmath::V2::Omstr, ::Openmath::V3::Omstr
          Math::Function::Text.new(node.value.join)
        when ::Openmath::V2::Oma, ::Openmath::V3::Oma
          application(node)
        when ::Openmath::V2::Ome, ::Openmath::V3::Ome,
             ::Openmath::V2::Ombind, ::Openmath::V3::Ombind
          Semantic.new(node.to_xml)
        else
          raise UnsupportedError.new(node.class.name, :openmath)
        end
      end

      private

      def float_literal(node)
        ::Openmath::Evaluation::Evaluator.float_literal(node)
      rescue ArgumentError
        raise UnsupportedError.new(node.to_xml, :openmath)
      end

      def application(node)
        children = ::Openmath::Evaluation::Evaluator.ordered_children(node)
        operator = children.first
        unless operator.is_a?(::Openmath::V2::Oms) || operator.is_a?(::Openmath::V3::Oms)
          raise UnsupportedError.new(node.to_s, :openmath)
        end

        key = "#{operator.cd}/#{operator.name}"
        check_binding(operator, key)
        # The pmquant quantity constructors evaluate from the retained
        # OpenMath source (Formula#evaluate); the node keeps the application
        # and refuses every presentation, like any unbound CD symbol.
        return Semantic.new(node.to_xml) if operator.cd == "pmquant"

        operands = children.drop(1).map { |child| operand(child) }
        arity = case key
                when "arith1/unary_minus", "nums1/integer", "logic1/not", *UNARY_FUNCTIONS.keys then 1
                when "logic1/and", "logic1/or", "logic1/xor" then 2..Float::INFINITY
                when "arith1/plus", "arith1/times", "arith1/max", "arith1/min" then 1..Float::INFINITY
                else 2
                end
        raise UnsupportedError.new(key, :openmath) unless arity === operands.size

        case key
        when "arith1/unary_minus"
          Math::Formula.new([Math::Symbols::Minus.new, operands.first])
        when "logic1/not"
          Math::Formula.new([Math::Symbols::Lnot.new, operands.first])
        when "arith1/power"
          Math::Function::Power.new(*operands)
        when "nums1/integer"
          unless operands.first.is_a?(Math::Number) && operands.first.value.match?(/\A[+-]?\d+\z/)
            raise UnsupportedError.new(key, :openmath)
          end

          operands.first
        when "nums1/rational"
          Math::Function::Frac.new(*operands)
        when *UNARY_FUNCTIONS.keys
          UNARY_FUNCTIONS.fetch(key).new(operands.first)
        when "arith1/max", "arith1/min"
          arguments = operands.flat_map.with_index do |item, index|
            index.zero? ? [item] : [Math::Symbols::Comma.new, item]
          end
          fenced = Math::Function::Fenced.new(
            Math::Symbols::Paren::Lround.new, arguments, Math::Symbols::Paren::Rround.new
          )
          APPLICATIONS.fetch(key).new(fenced)
        else
          infix = APPLICATIONS[key]
          raise UnsupportedError.new(key, :openmath) unless infix

          Math::Formula.new(operands.flat_map.with_index do |item, index|
            index.zero? ? [item] : [infix.new, item]
          end)
        end
      end

      def check_binding(operator, key)
        unless ::Openmath::Evaluation::BindingTable.default.lookup(operator.cd, operator.name)
          raise UnsupportedError.new(key, :openmath)
        end

        base = operator.cdbase&.delete_suffix("/")
        return if base.nil? || base == "http://www.openmath.org/cd"
        return if operator.cd == "pmquant" && base == "http://www.plurimath.org/cd"

        raise UnsupportedError.new(key, :openmath)
      end

      def operand(node)
        converted = convert(node)
        return converted unless converted.is_a?(Math::Formula) && converted.value.size > 1

        Math::Function::Fenced.new(Math::Symbols::Paren::Lround.new,
                                   converted.value, Math::Symbols::Paren::Rround.new)
      end
    end
  end
end
