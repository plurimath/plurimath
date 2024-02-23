# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Overset < BinaryFunction
        attr_accessor :options
        FUNCTION = {
          name: "overset",
          first_value: "base",
          second_value: "supscript",
        }.freeze

        def initialize(
          parameter_one = nil,
          parameter_two = nil,
          options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def to_mathml_without_math_tag
          value_array = [
            validate_mathml_fields(parameter_two),
            validate_mathml_fields(parameter_one),
          ]
          Utility.update_nodes(ox_element("mover", attributes: options), value_array)
        end

        def to_omml_without_math_tag(display_style)
          if !display_style
            power = Power.new(parameter_one, parameter_two)
            return power.to_omml_without_math_tag(display_style)
          end

          limupp   = Utility.ox_element("limUpp", namespace: "m")
          limupppr = Utility.ox_element("limUppPr", namespace: "m")
          limupppr << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            limupp,
            [
              limupppr,
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "lim"),
            ],
          )
          [limupp]
        end

        def line_breaking(obj)
          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(parameter_one, Utility.filter_values(obj.value)))
            self.parameter_one = nil
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_two, nil, parameter_one, fourth_value, { type: "undOvr" })
        end

        def is_nary_function?
          parameter_two.is_nary_function? || parameter_two.is_nary_symbol?
        end
      end
    end
  end
end
