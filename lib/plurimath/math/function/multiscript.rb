# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        def to_omml_without_math_tag
          pre_element = Utility.ox_element("sPre", namespace: "m")
          pr_element  = Utility.ox_element("sPrePr", namespace: "m")
          Utility.update_nodes(
            pre_element,
            [
              pr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              sub_parameter,
              sup_parameter,
              e_parameter,
            ],
          )
          [pre_element]
        end

        protected

        def sub_parameter
          sub_tag = Utility.ox_element("sub", namespace: "m")
          return empty_tag(sub_tag) unless parameter_one

          Utility.update_nodes(sub_tag, insert_t_tag(parameter_two))
        end

        def sup_parameter
          sup_tag = Utility.ox_element("sup", namespace: "m")
          return empty_tag(sup_tag) unless parameter_two

          Utility.update_nodes(sup_tag, insert_t_tag(parameter_three))
        end

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return empty_tag(e_tag) unless parameter_three

          Utility.update_nodes(e_tag, insert_t_tag(parameter_one))
        end
      end
    end
  end
end
