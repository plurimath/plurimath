# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Semantics < BinaryFunction
        FUNCTION = {
          name: "semantics",
          first_value: "first argument",
          second_value: "second argument",
        }.freeze

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = other_tags(parameter_two)
          Utility.update_nodes(
            Utility.ox_element("semantics"),
            second_value.insert(0, first_value),
          )
        end

        def to_latex
          parameter_one&.to_latex
        end

        def to_asciimath
          parameter_one&.to_asciimath
        end

        def to_omml_without_math_tag(display_style)
          Array(parameter_one.insert_t_tag(display_style))
        end

        protected

        def other_tags(array)
          contented = []
          array&.each do |hash|
            hash.each do |tag, content|
              tag_element = Utility.ox_element(tag&.to_s)
              contented << Utility.update_nodes(
                tag_element,
                content&.map(&:to_mathml_without_math_tag),
              )
            end
          end
          contented
        end
      end
    end
  end
end
