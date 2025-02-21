# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      class Mrow < Formula
        attr_accessor :is_mrow

        def initialize(
          value = [],
          left_right_wrapper = true,
          display_style: true,
          input_string: nil
        )
          super
          @is_mrow = true
        end

        def element_order=(value)
          @value = validated_order(value&.map(&:name), rejectable_array: ["comment"])
        end

        def content; end

        def content=(value)
          arr_value = Array(value)
          if no_content_in?(arr_value)
            delete_all_text
          else
            validate_text_order(
              arr_value.map { |val| validate_symbols(val) unless val.strip.empty? }
            )
          end
          organize_value
        end

        def is_mrow?
          @is_mrow
        end

        private

        def organize_value
          return if value.any?(String)
          return unless is_mrow

          value.each_with_index do |element, index|
            update_current_element(element, value, index)
            if value[index + 1].is_a?(Math::Function::Mod)
              update_mod_function(value, index)
            elsif unary_function_updatable?(value, element, index)
              unary_function_update(value, index)
            elsif value.first.paren? && value.last.paren?
              organize_fencing(value)
            elsif valid_underset_function?(element)
              value[index] = new_nary_element(element, value)
            elsif valid_underover_function?(element)
              replace_with_nary_function(element, value, index)
            elsif ternary_function_third_value_present?(element)
              element.parameter_three = value.delete_at(index + 1)
            end
          end
        end

        def update_current_element(element, value, index)
          if first_and_last_values_nil?(value)
            replace_symbols_with_parens(value)
          elsif element.class_name == "symbol" && element.value.nil?
            element.value = ""
          end
        end

        def validate_text_order(value)
          @value.each_with_index do |item, index|
            next unless item == "text"

            if value.first
              @value[index] = value.shift
            else
              value.shift
              @value.delete_at(index)
            end
          end
        end

        def delete_all_text
          @value.delete("text")
        end

        def no_content_in?(value)
          value.nil? || value.empty? || value&.all? { |val| val.strip.empty? }
        end

        def first_and_last_values_nil?(value)
          value.first.class_name == "symbol" &&
            value.first.value.nil? &&
            value.last.class_name == "symbol" &&
            value.last.value.nil?
        end

        def replace_symbols_with_parens(value)
          value[0] = Math::Symbols::Paren::OpenParen.new
          value[-1] = Math::Symbols::Paren::CloseParen.new
        end

        def nary_function_or_symbol?(element)
          element.is_nary_function? || element.is_nary_symbol?
        end

        def valid_underover_function?(element)
          element.is_a?(Math::Function::Underover) &&
            nary_function_or_symbol?(element.parameter_one)
        end

        def valid_underset_function?(element)
          element.is_a?(Math::Function::Underset) &&
            nary_function_or_symbol?(element.parameter_two)
        end

        def unary_function_updatable?(value, element, index)
          value.length > 1 &&
              element.is_unary? &&
              value[index + 1] &&
              Plurimath::Utility::UNARY_CLASSES.include?(element.class_name)
        end

        def ternary_function_third_value_present?(element)
          element.is_ternary_function? &&
            element.any_value_exist? &&
            element.parameter_three.nil?
        end

        def update_mod_function(value, index)
          mod_obj = value[index + 1]
          mod_obj.parameter_one = filter_values(
            value.delete_at(index),
            array_to_instance: true
          )
          mod_obj.parameter_two = filter_values(
            value.delete_at(index + 1),
            array_to_instance: true
          )
        end

        def unary_function_update(value, index)
          element = value.delete_at(index)
          element.parameter_one = filter_values(
            value.delete_at(index),
            array_to_instance: true
          )
          value.insert(index, element)
        end

        def organize_fencing(value)
          if value[1].is_a?(Math::Function::Table) && value.length == 3
            table = value[1]
            table.open_paren = value.shift
            table.close_paren = value.pop
          else
            @value = [
              Function::Fenced.new(value.shift, value, value.pop)
            ]
          end
        end

        def new_nary_element(element, value)
          value.shift
          nary = Plurimath::Math::Function::Nary.new(
            element.parameter_two,
            element.parameter_one,
            nil,
            filter_values(value.shift(value.length), array_to_instance: true),
            { type: "undOvr" }
          )
          nary
        end

        def replace_with_nary_function(element, value, index)
          fourth_value = value.delete_at(index + 1)
          organize_value(fourth_value) if fourth_value.is_mrow?
          value[index] = Math::Function::Nary.new(
            element.parameter_one,
            element.parameter_two,
            element.parameter_three,
            filter_values(fourth_value, array_to_instance: true),
            { type: "undOvr" }
          )
        end
      end
    end
  end
end
