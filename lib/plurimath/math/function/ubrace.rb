# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ubrace < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          "ubrace#{first_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\underbrace#{first_value}"
        end

        def to_mathml_without_math_tag(intent)
          mo_tag = ox_element("mo") << "&#x23df;"
          return mo_tag unless parameter_one

          over_tag = ox_element("munder")
          over_tag.set_attr(attributes) if attributes && !attributes.empty?
          Utility.update_nodes(
            over_tag,
            [
              parameter_one.to_mathml_without_math_tag(intent),
              mo_tag,
            ],
          )
        end

        def tag_name
          "underover"
        end

        def omml_tag_name
          "undOvr"
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style)
          return r_element("⏟", rpr_tag: false) unless parameter_one

          symbol = Symbols::Symbol.new("⏟")
          Underset.new(parameter_one, symbol).to_omml_without_math_tag(true)
        end

        def to_unicodemath
          first_value = "(#{parameter_one&.to_unicodemath})" if parameter_one
          "⏟#{first_value}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end
      end

      Underbrace = Ubrace
    end
  end
end
