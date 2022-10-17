# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class TernaryFunction
        attr_accessor :parameter_one, :parameter_two, :parameter_three

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
        end

        def to_asciimath
          first_value = parameter_one&.to_asciimath
          second_value = "_(#{parameter_two.to_asciimath})" if parameter_two
          third_value = "^(#{parameter_three.to_asciimath})" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end

        def to_mathml_without_math_tag
          first_value  = parameter_one&.to_mathml_without_math_tag
          second_value = parameter_two&.to_mathml_without_math_tag
          third_value  = parameter_three&.to_mathml_without_math_tag
          body_value   = "#{first_value}#{second_value}#{third_value}"
          "<m#{class_name}>#{body_value}</m#{class_name}>"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          third_value = "<i>#{parameter_three.to_html}</i>" if parameter_three
          first_value + second_value + third_value
        end

        def to_omml_without_math_tag
          r_tag = Utility.omml_element("r", namespace: "m")
          r_tag << parameter_one.to_omml_without_math_tag if parameter_one
          r_tag << parameter_two.to_omml_without_math_tag if parameter_two
          r_tag << parameter_three.to_omml_without_math_tag if parameter_three
          r_tag
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
