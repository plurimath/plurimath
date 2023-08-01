# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction < Core
        attr_accessor :parameter_one

        def initialize(parameter_one = nil)
          parameter_one  = parameter_one.to_s if parameter_one.is_a?(Parslet::Slice)
          @parameter_one = parameter_one
          Utility.validate_left_right([parameter_one])
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one
        end

        def to_asciimath
          value = if Utility::UNARY_CLASSES.any?(class_name)
                    asciimath_value
                  elsif parameter_one
                    "(#{asciimath_value})"
                  end
          "#{class_name}#{value}"
        end

        def to_mathml_without_math_tag
          row_tag = Utility.ox_element("mrow")
          tag_name = Utility::UNARY_CLASSES.include?(class_name) ? "mi" : "mo"
          new_arr = [Utility.ox_element(tag_name) << class_name]
          if parameter_one
            new_arr += mathml_value
            Utility.update_nodes(row_tag, new_arr)
          else
            new_arr.first
          end
        end

        def to_latex
          first_value = "{#{latex_value}}" if parameter_one
          "\\#{class_name}#{first_value}"
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
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, omml_value) if parameter_one
          Utility.update_nodes(
            func,
            [
              funcpr,
              fname,
              me,
            ],
          )
          [func]
        end

        protected

        def asciimath_value
          return "" unless parameter_one

          case parameter_one
          when Array
            parameter_one.compact.map(&:to_asciimath).join
          else
            parameter_one.to_asciimath
          end
        end

        def mathml_value
          case parameter_one
          when Array
            parameter_one.compact.map(&:to_mathml_without_math_tag)
          else
            Array(parameter_one&.to_mathml_without_math_tag)
          end
        end

        def latex_value
          if parameter_one.is_a?(Array)
            return parameter_one&.compact&.map(&:to_latex)&.join(" ")
          end

          parameter_one&.to_latex
        end

        def omml_value
          if parameter_one.is_a?(Array)
            return parameter_one&.compact&.map(&:insert_t_tag)
          end

          Array(parameter_one&.insert_t_tag)
        end
      end
    end
  end
end
