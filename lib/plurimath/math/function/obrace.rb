# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Obrace < UnaryFunction
        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\overbrace#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "&#x23de;")
          if parameter_one
            over_tag = Utility.ox_element("mover")
            arr_value = mathml_value
            Utility.update_nodes(over_tag, (arr_value << mo_tag))
          else
            mo_tag
          end
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag
          groupchr = Utility.ox_element("groupChr", namespace: "m")
          Utility.update_nodes(
            groupchr,
            [
              group_chr_pr,
              omml_parameter(parameter_one, tag_name: "e"),
            ],
          )
          [groupchr]
        end

        protected

        def group_chr_pr
          groupchrpr = Utility.ox_element("groupChrPr", namespace: "m")
          vert_jc = Utility.ox_element("vertJc", namespace: "m", attributes: { "m:val": "bot" })
          chr = Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "⏞" })
          pos = Utility.ox_element("pos", namespace: "m", attributes: { "m:val": "top" })
          Utility.update_nodes(
            groupchrpr,
            [
              chr,
              pos,
              vert_jc,
            ],
          )
        end
      end

      Overbrace = Obrace
    end
  end
end
