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
          third_value = invert_unicode_symbols.empty? ? class_name : invert_unicode_symbols
          "<mo>#{third_value}</mo>#{first_value}#{second_value}"
        end

        def invert_unicode_symbols
          Mathml::Constants::UNICODE_SYMBOLS.invert[class_name].to_s
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_latex}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_latex}</i>" if parameter_two
          "<i>#{class_name}</i>#{first_value}#{second_value}"
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
