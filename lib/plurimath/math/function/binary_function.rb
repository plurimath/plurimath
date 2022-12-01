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
          "#{wrapped(parameter_one)}#{wrapped(parameter_two)}"
        end

        def wrapped(field)
          return "" unless field

          field.is_a?(Math::Formula) ? field.to_asciimath : "(#{field.to_asciimath})"
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two
        end

        def to_mathml_without_math_tag
          mrow_tag = Utility.ox_element("mrow")
          mo_tag = Utility.ox_element("mo") << invert_unicode_symbols.to_s
          first_value = parameter_one&.to_mathml_without_math_tag if parameter_one
          second_value = parameter_two&.to_mathml_without_math_tag if parameter_two
          Utility.update_nodes(
            mrow_tag,
            [
              mo_tag,
              first_value,
              second_value,
            ],
          )
        end

        def invert_unicode_symbols
          Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          "<i>#{class_name}</i>#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          r_tag << parameter_one.to_omml_without_math_tag if parameter_one
          r_tag << parameter_two.to_omml_without_math_tag if parameter_two
          r_tag
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
