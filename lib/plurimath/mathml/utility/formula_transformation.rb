# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      module FormulaTransformation
        private

        def filter_values(value, array_to_instance: false, replacing_order: true)
          return value unless value.is_a?(Array)
          return array_to_instance ? nil : value if value.empty?

          if is_a?(Math::Formula) && value.length == 1 && value.first.is_mstyle?
            @displaystyle = value.first.displaystyle
          end

          if value.length == 1 && value.all? { |val| val.is_a?(Math::Formula) }
            if array_to_instance
              filter_values(value.first.value, array_to_instance: true)
            else
              value.first
            end
          elsif value.is_a?(Array) && value.any?(Math::Formula::Mrow)
            value.each_with_index do |element, index|
              next unless element.is_a?(Math::Formula::Mrow)

              value[index] = filter_values(
                Array(element),
                array_to_instance: true,
                replacing_order: replacing_order,
              )
            end
            value
          elsif value_is_ternary_or_nary?(value)
            value.first.parameter_three = value.delete_at(1)
            filter_values(
              Array(value),
              array_to_instance: array_to_instance,
              replacing_order: replacing_order,
            )
          elsif ternary_naryable?(value)
            [
              Math::Function::Nary.new(
                value.first.parameter_one,
                value.first.parameter_two,
                value.first.parameter_three,
                value.last,
              ),
            ]
          elsif overset_naryable?(value)
            [
              Math::Function::Nary.new(
                value.first.parameter_two,
                nil,
                value.first.parameter_one,
                value.last,
                { type: "undOvr" },
              ),
            ]
          elsif power_naryable?(value)
            [
              Math::Function::Nary.new(
                value.first.parameter_one,
                nil,
                value.first.parameter_two,
                value.last,
                { type: "subSup" },
              ),
            ]
          elsif array_to_instance && replacing_order
            value.length > 1 ? Math::Formula.new(value) : value.first
          else
            value
          end
        end

        def validate_symbols(value)
          case value
          when Array
            array_validations(value)
          when Math::Symbols::Symbol
            return value if value.value.nil?

            instance = mathml_symbol_to_class(value.value)
            if value&.options&.any? && instance.is_a?(Math::Symbols::Symbol)
              instance.options = value.options
            end
            instance
          when String
            mathml_symbol_to_class(value)
          end
        end

        def array_validations(value)
          value.each_with_index do |val, index|
            next unless val.is_a?(Math::Symbols::Symbol)

            value[index] = mathml_symbol_to_class(val.value) unless val.value.nil?
          end
          value
        end

        def mathml_symbol_to_class(symbol)
          Plurimath::Utility.mathml_unary_classes(
            Array(symbol),
            lang: :mathml,
          )
        end

        def value_is_ternary_or_nary?(value)
          return if value.any?(String)

          value.length >= 2 &&
            value.first.is_ternary_function? &&
            value.first.parameter_three.nil? &&
            (!value.first.parameter_one.nil? || !value.first.parameter_two.nil?)
        end

        def ternary_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::PowerBase) &&
            value.first.parameter_one.is_nary_symbol?
        end

        def overset_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::Overset) &&
            value.first.parameter_two.is_nary_symbol?
        end

        def power_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::Power) &&
            value.first.parameter_one.is_nary_symbol?
        end
      end
    end
  end
end
