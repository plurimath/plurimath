# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Underset < BinaryFunction
        FUNCTION = {
          name: "underscript",
          first_value: "underscript value",
          second_value: "base expression",
        }.freeze

        def to_mathml_without_math_tag
          first_value = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          Utility.update_nodes(
            Utility.ox_element("munder"),
            [
              second_value,
              first_value,
            ],
          )
        end

        def to_omml_without_math_tag(display_style)
          if !display_style
            base = Base.new(parameter_one, parameter_two)
            return base.to_omml_without_math_tag(display_style)
          end

          limlow   = Utility.ox_element("limLow", namespace: "m")
          limlowpr = Utility.ox_element("limLowPr", namespace: "m")
          limlowpr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limlow,
            [
              limlowpr,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "lim"),
            ],
          )
          [limlow]
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value)))
          end
        end
      end
    end
  end
end
