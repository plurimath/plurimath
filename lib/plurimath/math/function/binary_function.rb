# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class BinaryFunction
        attr_accessor :parameter_one, :parameter_two

        def initialize(parameter_one = nil, parameter_two = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
        end

        def to_asciimath
          "#{class_name}#{value_to_asciimath}"
        end

        def value_to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two.to_asciimath})" if parameter_two
          "#{first_value}#{second_value}"
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two
        end

        def to_mathml_without_math_tag
          first_value = parameter_one.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two.to_mathml_without_math_tag if parameter_two
          "<mo>#{Mathml::Constants::UNICODE_SYMBOLS.invert[class_name].to_s.empty? ? class_name : Mathml::Constants::UNICODE_SYMBOLS.invert[class_name].to_s}</mo>#{first_value}#{second_value}"
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
