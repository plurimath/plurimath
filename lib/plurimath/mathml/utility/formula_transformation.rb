# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      module FormulaTransformation
        CONDITIONAL_COMMON_UNARY_FUNCTIONS = %w[
          scarries
          phantom
          mpadded
          merror
        ].freeze
        SYMBOL_UPDATABLE_FUNCTIONS = %w[
          font_style
          linebreak
        ].freeze

        private

        def update_temp(value)
          @temp_mathml_order = Array(value)
        end

        def update_temp_order(value, order_name)
          update_temp(
            replace_order_with_value(
              Array(@temp_mathml_order),
              Array(update_temp_mathml_values(value)),
              order_name,
            ),
          )
        end

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
              value.first.value
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

            value[index] = mathml_symbol_to_class(val.value)
          end
          value
        end

        def mathml_symbol_to_class(symbol)
          Plurimath::Utility.mathml_unary_classes(
            Array(symbol),
            lang: :mathml,
          )
        end

        def replace_order_with_value(order, value, tag_name)
          value_index = 0
          value_array = Array(value)

          order.each_with_object([]) do |item, result|
            next result << item if item != tag_name
            next if value_index >= value_array.length

            result << value_array[value_index]
            value_index += 1
          end
        end

        def update_temp_mathml_values(value)
          value.each_with_index do |element, index|
            next unless element.respond_to?(:temp_mathml_order)

            if element.symbol? && element.temp_mathml_order&.none?
              value[index] = validate_symbols(element)
            end

            next unless element.temp_mathml_order&.any?

            if element.is_ternary_function?
              if element.is_a?(Math::Function::Multiscript)
                multi = multiscript(element.clear_temp_order)
                element.parameter_one = multi[0]
                element.parameter_two = filter_values(Array(multi[1])[0])
                element.parameter_three = filter_values(Array(multi[1])[1])
              elsif first_element_is_ternary_function?(element)
                new_element = ternary_element_from(element.temp_mathml_order)
                new_element.parameter_one = filter_values(
                  Array(element.temp_mathml_order.shift),
                  array_to_instance: true,
                )
                new_element.parameter_two = filter_values(
                  Array(element.temp_mathml_order.shift),
                  array_to_instance: true,
                )
                value[index] = new_element
              elsif first_element_is_binary_function?(element)
                new_element = element.temp_mathml_order.shift
                new_element.parameter_one = element.temp_mathml_order.shift
                new_element.parameter_two = element.temp_mathml_order.shift
                value[index] = new_element
              elsif element.is_a?(Math::Function::PowerBase)
                update_power_base_value(element)
              else
                element.parameter_one = element.temp_mathml_order.shift
                element.parameter_two = element.temp_mathml_order.shift
                element.parameter_three = element.temp_mathml_order.shift
              end
            elsif element.is_binary_function?
              update_binary_function_value(element, value, index)
            elsif element.is_unary?
              element.parameter_one = update_unary_function(element)
            elsif element.symbol? && symbol_updatable?(element)
              update_symbol(element, value, index)
            end
          end
          value
        end

        def validated_order(order, rejectable_array: nil)
          rejectable_array ||= ["comment", "text"]
          order.reject { |str| rejectable_array.include?(str) }
        end

        def value_is_ternary_or_nary?(value)
          return if value.any?(String)

          value.length >= 2 &&
            value.first.is_ternary_function? &&
            value.first.parameter_three.nil? &&
            (!value.first.parameter_one.nil? || !value.first.parameter_two.nil?)
        end

        def first_element_is_ternary_function?(element)
          (
            element.temp_mathml_order.first&.is_ternary_function? &&
            !(
              element.temp_mathml_order.first.is_a?(Math::Function::FontStyle) ||
              element.temp_mathml_order.first.is_a?(Math::Function::Fenced)
            )
          ) ||
            ternary_filtered_function?(element)
        end

        def first_element_is_binary_function?(element)
          (
            element.temp_mathml_order.first&.is_binary_function? &&
            !element.temp_mathml_order.first.is_a?(Math::Function::FontStyle)
          ) ||
            binary_filtered_function?(element)
        end

        def binary_filtered_function?(element)
          new_element = filter_values(
            [element.temp_mathml_order.first],
            array_to_instance: true,
          )
          new_element&.is_binary_function? && !new_element.all_values_exist?
        end

        def ternary_filtered_function?(element)
          new_element = filter_values(
            [element.temp_mathml_order.first],
            array_to_instance: true,
          )
          new_element&.is_ternary_function? &&
            !new_element.all_values_exist?
        end

        def ternary_element_from(order)
          element = order.shift
          return element if element.is_ternary_function?

          filter_values([element], array_to_instance: true)
        end

        def period_to_dot(element, value, index)
          return element unless element.is_a?(Math::Symbols::Period)

          value[index] = Math::Function::Dot.new
        end

        def multiscript(value)
          value.slice_before("mprescripts").map do |val|
            base_value   = val.shift
            val          = Plurimath::Utility.nil_to_none_object(val)
            part_val     = val.partition.with_index { |_, i| i.even? }
            first_value  = part_val[0].empty? ? nil : part_val[0]
            second_value = part_val[1].empty? ? nil : part_val[1]
            if base_value.to_s.include?("mprescripts")
              [first_value, second_value]
            else
              Math::Function::PowerBase.new(
                filter_values(base_value, array_to_instance: true),
                filter_values(first_value, array_to_instance: true),
                filter_values(second_value, array_to_instance: true),
              )
            end
          end
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

        def update_power_base_value(element)
          element.parameter_one = filter_values(
            Array(element.temp_mathml_order.shift),
            array_to_instance: true,
          )
          element.parameter_two = filter_values(
            Array(element.temp_mathml_order.shift),
            array_to_instance: true,
          )
          return unless element.is_a?(Math::Function::PowerBase)

          element.parameter_three = filter_values(
            Array(element.temp_mathml_order.shift),
            array_to_instance: true,
          )
        end

        def update_overset_value(element, value, index)
          case element.temp_mathml_order[1].class_name
          when "obrace", "ubrace"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = element.temp_mathml_order.shift
          when "hat", "ddot"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = filter_values(
              Array(element.temp_mathml_order.shift),
              array_to_instance: true,
            )
            return unless element.respond_to?(:options)

            new_element.attributes = element.options
          when "period", "dot"
            new_element = period_to_dot(
              element.temp_mathml_order.pop,
              value,
              index,
            )
            new_element.parameter_one = filter_values(
              Array(element.temp_mathml_order.shift),
              array_to_instance: true,
            )
            new_element.attributes = element.options
          when "bar"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = element.temp_mathml_order.shift
          when "vec"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = filter_values(
              Array(element.temp_mathml_order.shift),
              array_to_instance: true,
            )
            new_element.attributes = element.options
          when "ul", "underline"
            element.temp_mathml_order.pop
            new_element = Math::Function::Bar.new(
              filter_values(
                element.clear_temp_order,
                array_to_instance: true,
              ),
              element.options,
            )
          when "tilde"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = filter_values(
              element.clear_temp_order,
              array_to_instance: true,
            )
            new_element.attributes = element.options
          else
            element.parameter_two = element.temp_mathml_order.shift
            element.parameter_one = element.temp_mathml_order.shift
          end
          value[index] = new_element if new_element
        end

        def update_underset_value(element, value, index)
          return if update_underset_first_temp_element(element, value, index)

          case element.temp_mathml_order[1]&.class_name
          when "obrace", "ubrace", "ul", "underline"
            new_element = element.temp_mathml_order.pop
            new_element.parameter_one = element.temp_mathml_order.shift
          when "bar"
            element.temp_mathml_order.pop
            new_element = Math::Function::Ul.new(
              filter_values(
                element.clear_temp_order,
                array_to_instance: true,
              ),
              element.options,
            )
          else
            element.parameter_two = element.temp_mathml_order.shift
            element.parameter_one = element.temp_mathml_order.shift
          end
          value[index] = new_element if new_element
        end

        def update_underset_first_temp_element(element, value, index)
          case element.temp_mathml_order[0]
          when Math::Function::Vec,
              ->(block_element) { updatable_ternary_function?(block_element) }
            new_element = element.temp_mathml_order.shift
            new_element.parameter_one = element.temp_mathml_order.shift
            value[index] = new_element
            return unless new_element.is_a?(Math::Function::Vec)

            new_element.attributes = element.options
          end
        end

        def updatable_ternary_function?(element)
          element.is_ternary_function? && !element.any_value_exist?
        end

        def update_binary_function_value(element, value, index)
          case element
          when Math::Function::Semantics, Math::Function::Stackrel
            element.parameter_one = filter_values(
              Array(element.clear_temp_order),
              array_to_instance: true,
            )
          when Math::Function::Overset
            update_overset_value(element, value, index)
          when Math::Function::Underset
            update_underset_value(element, value, index)
          when Math::Function::Power, Math::Function::Base
            update_power_base_value(element)
          when Math::Function::Td
            element.parameter_one = element.clear_temp_order
          when Math::Function::Root
            element.parameter_two = element.temp_mathml_order.shift
            element.parameter_one = element.temp_mathml_order.shift
          when Math::Function::Menclose
            element.parameter_two = filter_values(
              Array(element.clear_temp_order),
              array_to_instance: true,
            )
          else
            element.parameter_one = element.temp_mathml_order.shift
            element.parameter_two = element.temp_mathml_order.shift
          end
        end

        def update_unary_function(element)
          case element.class_name
          when *CONDITIONAL_COMMON_UNARY_FUNCTIONS
            filter_values(
              element.clear_temp_order,
              array_to_instance: true,
            )
          when "sqrt"
            element.temp_mathml_order.shift
          else
            element.clear_temp_order
          end
        end

        def symbol_updatable?(element)
          temp_element = element.temp_mathml_order.first
          return false unless temp_element

          temp_element.is_a?(Math::Function::FontStyle) ||
            temp_element.is_a?(Math::Function::Linebreak)
        end

        def update_symbol(element, value, index)
          new_element = element.temp_mathml_order.shift
          case new_element
          when Math::Function::FontStyle
            new_element.parameter_one = validate_symbols(element)
            value[index] = new_element
          when Math::Function::Linebreak
            new_element.parameter_one = validate_symbols(element)
            value[index] = new_element
          end
        end
      end
    end
  end
end
