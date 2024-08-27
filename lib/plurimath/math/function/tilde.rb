# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Tilde < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_mathml_without_math_tag(intent, options:)
          mover = ox_element("mover")
          mover[:accent] = attributes[:accent] if attributes&.dig(:accent)
          second_value = parameter_one.to_mathml_without_math_tag(intent, options: options) if parameter_one
          Utility.update_nodes(mover, [second_value, ox_element("mo") << "~"])
        end

        def to_omml_without_math_tag(display_style)
          return r_element("~", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accent]
            acc_tag(display_style)
          else
            symbol = Symbols::Symbol.new("~")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true)
          end
        end

        def validate_function_formula
          false
        end

        def to_unicodemath
          "#{unicodemath_parens(parameter_one)}̃"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        protected

        def acc_tag(display_style)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "˜" }))
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
