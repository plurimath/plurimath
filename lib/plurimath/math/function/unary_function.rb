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
          "(#{parameter_one.to_asciimath})" unless parameter_one.nil?
        end

        def to_mathml_without_math_tag
          <<~LATEX
            <mrow>
              <mo>#{class_name}</mo>
              #{parameter_one&.to_mathml_without_math_tag}
            </mrow>
          LATEX
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
          func   = Utility.omml_element("m:func")
          funcpr = Utility.omml_element("m:funcPr")
          funcpr << Utility.pr_element("m:ctrl", true)
          fname  = Utility.omml_element("m:fName")
          mr  = Utility.omml_element("m:r")
          rpr = Utility.rpr_element
          mt  = Utility.omml_element("m:t") << class_name
          fname << Utility.update_nodes(mr, [rpr, mt])
          first_value = parameter_one.to_omml_without_math_tag
          me = Utility.omml_element("m:e") << first_value
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
