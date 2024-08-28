# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Dot < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_mathml_without_math_tag(intent, options:)
          dot_tag = Utility.ox_element("mo") << "."
          return dot_tag unless parameter_one

          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options)
          dot_tag = (Utility.ox_element("mo") << ".")
          over_tag = Utility.ox_element("mover")
          over_tag[:accent] = attributes[:accent] if attributes && attributes[:accent]
          Utility.update_nodes(
            over_tag,
            [
              first_value,
              dot_tag,
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element(".", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accent]
            acc_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new(".")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true, options: options)
          end
        end

        def to_unicodemath(options:)
          first_value = unicodemath_parens(parameter_one, options: options) if parameter_one
          "#{first_value}̇"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        protected

        def acc_tag(display_style, options:)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << Utility.ox_element(
            "chr",
            namespace: "m",
            attributes: { "m:val": "." },
          )
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
