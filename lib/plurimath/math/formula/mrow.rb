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
          input_string: nil,
          unitsml: false
        )
          super
          @is_mrow = true
        end

        def element_order=(value)
          @value = validated_order(value, rejectable_array: ["comment"])
        end

        def content; end

        def content=(value)
          if no_content_in?(value)
            delete_all_text
          else
            new_val = value&.map do |val|
              validate_symbols(val) unless val.strip.empty?
            end
            validate_text_order(new_val)
          end
          organize_value
        end

        private

        def organize_value
          return if value.any?(String)
          return unless is_mrow

          unary_classes = Plurimath::Utility::UNARY_CLASSES
          value.each_with_index do |element, index|
            if value[index + 1].is_a?(Math::Function::Mod)
              mod_obj = value[index + 1]
              mod_obj.parameter_one = filter_values(
                value.delete_at(index),
                array_to_instance: true
              )
              mod_obj.parameter_two = filter_values(
                value.delete_at(index + 1),
                array_to_instance: true
              )
            elsif value.length > 1 && element.is_unary? && value[index + 1]
              if unary_classes.include?(element.class_name)
                new_element = value.delete_at(index)
                new_element.parameter_one = filter_values(
                  value.delete_at(index),
                  array_to_instance: true
                )
                value.insert(index, new_element)
              end
            elsif value.first.paren? && value.last.paren?
              @value = [
                Function::Fenced.new(value.shift, value, value.pop)
              ]
            elsif element.is_a?(Math::Function::Underset) &&
                (element.parameter_two.is_nary_function? ||
                  element.parameter_two.is_nary_symbol?)
              value.shift
              new_element = Plurimath::Math::Function::Nary.new(
                element.parameter_two,
                element.parameter_one,
                nil,
                filter_values(value.dup, array_to_instance: true),
                { type: "undOvr" }
              )
              value.clear
              value[index] = new_element
            elsif element.is_a?(Math::Function::Underover) &&
                (element.parameter_one.is_nary_function? ||
                  element.parameter_one.is_nary_symbol?)
              fourth_value = value.delete_at(index + 1)
              organize_value(fourth_value) if fourth_value.is_a?(Math::Formula::Mrow)
              value[index] = Math::Function::Nary.new(
                element.parameter_one,
                element.parameter_two,
                element.parameter_three,
                filter_values(
                  fourth_value,
                  array_to_instance: true
                ),
                { type: "undOvr" }
              )
            elsif element.is_ternary_function? &&
                element.any_value_exist? &&
                element.parameter_three.nil?
              element.parameter_three = value.delete_at(index + 1)
            end
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
      end
    end
  end
end
