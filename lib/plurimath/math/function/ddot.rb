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

        def to_mathml_without_math_tag(intent, options:)
          second_value = Utility.ox_element("mo") << ".."
          Utility.update_nodes(
            Utility.ox_element("mover", attributes: { accent: "true" }),
            mathml_value(intent, options: options) << second_value,
          )
        end

        def to_omml_without_math_tag(_, options:)
          return r_element("..", rpr_tag: false) unless parameter_one

          symbol = Symbols::Symbol.new("..")
          Overset.new(parameter_one, symbol).to_omml_without_math_tag(true, options: options)
        end

        def to_html(options:)
          first_value = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          "#{first_value}<i>..</i>"
        end

        def to_unicodemath(options:)
          "#{unicodemath_parens(parameter_one, options: options)}̈"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end
      end
    end
  end
end
