# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Hat < BinaryFunction
        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          "hat#{first_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\hat#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "^")
          return mo_tag unless parameter_one

          mover_tag = Utility.ox_element("mover")
          mover_tag.attributes.merge!(parameter_two) if parameter_two && !parameter_two.empty?
          Utility.update_nodes(
            mover_tag,
            [
              parameter_one&.to_mathml_without_math_tag,
              mo_tag,
            ],
          )
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style)
          return r_element("^", rpr_tag: false) unless all_values_exist?

          if parameter_two && parameter_two[:accent]
            accent_tag(display_style)
          else
            symbol = Symbol.new("&#x302;")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true)
          end
        end

        protected

        def accent_tag(display_style)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "̂" }))
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e", namespace: "m"),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
