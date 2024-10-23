# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      class Mrow < Formula
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
          @value = validated_order(value, rejected_array: ["comment"])
        end

        def content; end

        def content=(value)
          if value.all? { |val| val.strip.empty? }
            delete_all_text
          else
            new_val = value&.map do |val|
              validate_symbols(val) unless val.strip.empty?
            end
            validate_text_order(new_val)
          end
        end

        private

        def validate_text_order(value)
          @value.each_with_index do |item, index|
            next unless item == "text"

            if value.first
              @value[index] = value.shift
            else
              @value.delete_at(index)
            end
          end
        end

        def delete_all_text
          @value.delete("text")
        end
      end
    end
  end
end
