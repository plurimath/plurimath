# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction
        attr_accessor :parameter_one

        def initialize(parameter_one = nil)
          @parameter_one = parameter_one
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one
        end

        def to_asciimath
          "#{class_name}#{value_to_asciimath}"
        end

        def value_to_asciimath
          if parameter_one
            string = parameter_one.to_asciimath
            parameter_one.is_a?(Math::Formula) ? string : "(#{string})"
          end
        end

        def to_mathml_without_math_tag
          row_tag   = Utility.ox_element("mrow")
          row_value = Utility.ox_element("mo") << class_name
          first_value = parameter_one&.to_mathml_without_math_tag if parameter_one
          Utility.update_nodes(row_tag, [row_value, first_value])
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\#{class_name}#{first_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          "<i>#{class_name}</i>#{first_value}"
        end

        def to_omml_without_math_tag
          func   = Utility.ox_element("func", namespace: "m")
          funcpr = Utility.ox_element("funcPr", namespace: "m")
          funcpr << Utility.pr_element("ctrl", true, namespace: "m")
          fname  = Utility.ox_element("fName", namespace: "m")
          mr  = Utility.ox_element("r", namespace: "m")
          rpr = Utility.rpr_element
          mt  = Utility.ox_element("t", namespace: "m") << class_name
          fname << Utility.update_nodes(mr, [rpr, mt])
          first_value = parameter_one.to_omml_without_math_tag
          me = Utility.ox_element("e", namespace: "m") << first_value
          Utility.update_nodes(
            func,
            [
              funcpr,
              fname,
              me,
            ],
          )
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
