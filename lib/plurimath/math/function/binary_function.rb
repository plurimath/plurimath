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
          "#{class_name}#{wrapped(parameter_one)}#{wrapped(parameter_two)}"
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
              first_value,
              mo_tag,
              second_value,
            ],
          )
        end

        def to_latex
          first_value = latex_wrapped(parameter_one) if parameter_one
          second_value = latex_wrapped(parameter_two) if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          update_row_tag(r_tag, parameter_one) if parameter_one
          update_row_tag(r_tag, parameter_two) if parameter_two
          r_tag
        end

        def class_name
          self.class.name.split("::").last.downcase
        end

        protected

        def update_row_tag(tag, field)
          first_value = field.to_omml_without_math_tag
          first_value = if first_value.is_a?(String)
                          Utility.ox_element("t", namespace: "m") << first_value
                        end
          Utility.update_nodes(
            tag,
            first_value.is_a?(Array) ? first_value : [first_value],
          )
        end

        def latex_wrapped(field)
          if validate_function_formula(field)
            "{ \\left ( #{field.to_latex} \\right ) }"
          else
            "{#{field.to_latex}}"
          end
        end

        def validate_function_formula(field)
          unary_classes = (Utility::UNARY_CLASSES + ["obrace", "ubrace", "hat"])
          if field.is_a?(Formula)
            !(field.value.any?(Left) || field.value.any?(Right))
          elsif unary_classes.include?(field.class_name)
            false
          elsif field.class.name.include?("Function") || field.is_a?(FontStyle)
            !field.is_a?(Text)
          end
        end

        def mathml_wrapped(field)
          if validate_function_formula(field)
            mrow_tag = Utility.ox_element("mrow")
            open_paren = (Utility.ox_element("mo") << "(")
            close_paren = (Utility.ox_element("mo") << ")")
            Utility.update_nodes(
              mrow_tag,
              [
                open_paren,
                field.to_mathml_without_math_tag,
                close_paren,
              ],
            )
          else
            field.to_mathml_without_math_tag
          end
        end

        def wrapped(field)
          return "" unless field

          "(#{field.to_asciimath})"
        end

        def asciimath_base_value(field)
          if validate_function_formula(field)
            "(#{field.to_asciimath})"
          else
            field.to_asciimath
          end
        end

        def latex_base_value(field)
          if validate_function_formula(field)
            "{ \\left ( #{field.to_latex} \\right ) }"
          else
            field.to_latex
          end
        end

        def invert_unicode_symbols
          Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
        end
      end
    end
  end
end
