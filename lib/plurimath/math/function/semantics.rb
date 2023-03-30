# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Semantics < BinaryFunction
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

        def to_html
          parameter_one&.to_html
        end

        def to_omml_without_math_tag
          parameter_one&.to_omml_without_math_tag
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
