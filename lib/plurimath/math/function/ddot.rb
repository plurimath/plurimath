# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ddot < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_mathml_without_math_tag(intent)
          second_value = Utility.ox_element("mo") << ".."
          Utility.update_nodes(
            Utility.ox_element("mover", attributes: { accent: "true" }),
            mathml_value(intent) << second_value,
          )
        end

        def to_omml_without_math_tag(_)
          return r_element("..", rpr_tag: false) unless parameter_one

          symbol = Symbols::Symbol.new("..")
          Overset.new(parameter_one, symbol).to_omml_without_math_tag(true)
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          "#{first_value}<i>..</i>"
        end

        def to_unicodemath
          "#{unicodemath_parens(parameter_one)}̈"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end
      end
    end
  end
end
