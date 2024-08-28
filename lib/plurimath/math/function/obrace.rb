# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Obrace < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one.to_asciimath(options: options)})" if parameter_one
          "obrace#{first_value}"
        end

        def to_latex(options:)
          first_value = "{#{parameter_one.to_latex(options: options)}}" if parameter_one
          "\\overbrace#{first_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mo_tag = Utility.ox_element("mo") << "&#x23de;"
          return mo_tag unless parameter_one

          over_tag = Utility.ox_element("mover")
          over_tag.set_attr(attributes) if attributes && !attributes.empty?
          Utility.update_nodes(
            over_tag,
            [
              parameter_one.to_mathml_without_math_tag(intent, options: options),
              mo_tag,
            ],
          )
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("⏞", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accent]
            acc_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new("⏞")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true, options: options)
          end
        end

        def to_unicodemath(options:)
          "⏞(#{parameter_one&.to_unicodemath(options: options)})"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        protected

        def acc_tag(display_style, options:)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "⏞" }))
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e", namespace: "m", options: options),
            ],
          )
          [acc_tag]
        end
      end

      Overbrace = Obrace
    end
  end
end
