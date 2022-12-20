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
          value = "(#{asciimath_value})" if parameter_one
          "#{class_name}#{value}"
        end

        def asciimath_value
          return "" unless parameter_one

          case parameter_one
          when Array
            parameter_one.compact.map(&:to_asciimath).join
          else
            parameter_one.to_asciimath
          end
        end

        def to_mathml_without_math_tag
          row_tag = Utility.ox_element("mrow")
          new_arr = [Utility.ox_element("mo") << class_name]
          new_arr += mathml_value if parameter_one
          Utility.update_nodes(row_tag, new_arr)
        end

        def mathml_value
          case parameter_one
          when Array
            parameter_one.compact.map(&:to_mathml_without_math_tag)
          else
            Array(parameter_one.to_mathml_without_math_tag)
          end
        end

        def to_latex
          first_value = "{#{latex_value}}" if parameter_one
          "\\#{class_name}#{first_value}"
        end

        def latex_value
          case parameter_one
          when Array
            parameter_one.compact.map(&:to_latex).join
          else
            parameter_one.to_latex
          end
        end

        def to_html
          first_value = if parameter_one.is_a?(Array)
                          "<i>#{parameter_one.map(&:to_html).join}</i>"
                        elsif parameter_one
                          "<i>#{parameter_one.to_html}</i>"
                        end
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
          first_value = parameter_one.to_omml_without_math_tag if parameter_one
          me = Utility.ox_element("e", namespace: "m") << first_value if first_value
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
