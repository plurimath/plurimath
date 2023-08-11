# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Tilde < BinaryFunction
        def to_mathml_without_math_tag
          mover = Utility.ox_element("mover")
          mover.attributes.merge!({ accent: parameter_two[:accent]}) if parameter_two
          first_value = (Utility.ox_element("mo") << "~")
          second_value = parameter_one.to_mathml_without_math_tag if parameter_one
          Utility.update_nodes(mover, [second_value, first_value])
        end

        def to_omml_without_math_tag(display_style)
          return r_element("~", rpr_tag: false) unless all_values_exist?

          if parameter_two && parameter_two[:accent]
            acc_tag(display_style)
          else
            symbol = Symbol.new("~")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true)
          end
        end

        def validate_function_formula
          false
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
