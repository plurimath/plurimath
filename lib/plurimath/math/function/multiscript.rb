# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        FUNCTION = {
          name: "multiscript",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_omml_without_math_tag(display_style)
          pre_element = Utility.ox_element("sPre", namespace: "m")
          pr_element  = Utility.ox_element("sPrePr", namespace: "m")
          Utility.update_nodes(
            pre_element,
            [
              pr_element << Utility.pr_element("ctrl", true, namespace: "m"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
              omml_parameter(parameter_three, display_style, tag_name: "sup"),
              omml_parameter(parameter_one, display_style, tag_name: "e"),
            ],
          )
          [pre_element]
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            )
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_two.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(nil, Utility.filter_values(obj.value), parameter_three)
            )
            self.parameter_three = nil
          end
        end
      end
    end
  end
end
