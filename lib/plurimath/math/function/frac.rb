# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        attr_accessor :options
        FUNCTION = {
          name: "fraction",
          first_value: "numerator",
          second_value: "denominator",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       options = {})
          super(parameter_one, parameter_two)
          @options = options if options && !options&.empty?
        end

        def ==(object)
          super(object) &&
            object.options == options
        end

        def to_asciimath
          first_value = "(#{parameter_one&.to_asciimath})" if parameter_one
          second_value = "(#{parameter_two&.to_asciimath})" if parameter_two
          "frac#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag
          tag_name = hide_function_name ? "mrow" : "mfrac"
          mathml_value = [
            parameter_one&.to_mathml_without_math_tag,
            parameter_two&.to_mathml_without_math_tag,
          ]
          frac_tag = ox_element(tag_name)
          frac_tag.attributes.merge!(options) if tag_name == "mfrac" && options
          Utility.update_nodes(frac_tag, mathml_value)
        end

        def to_latex
          first_value = parameter_one&.to_latex
          two_value = parameter_two&.to_latex
          "\\frac{#{first_value}}{#{two_value}}"
        end

        def to_omml_without_math_tag(display_style)
          f_element   = Utility.ox_element("f", namespace: "m")
          Utility.update_nodes(
            f_element,
            [
              fpr_element,
              omml_parameter(parameter_one, display_style, tag_name: "num"),
              omml_parameter(parameter_two, display_style, tag_name: "den"),
            ],
          )
        end

        def to_unicodemath
          return unicodemath_fraction if options&.dig(:unicodemath_fraction)

          first_value = unicodemath_parens(parameter_one) if parameter_one
          second_value = unicodemath_parens(parameter_two) if parameter_two
          return "#{first_value}/#{second_value}" unless options

          return "#{first_value}¦#{second_value}" if options && options.key?(:linethickness)
          return"#{parameter_one.to_unicodemath}⊘#{parameter_two.to_unicodemath}" if options && options.key?(:displaystyle)
          return "#{first_value}∕#{second_value}" if options && options.key?(:ldiv)
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            frac = self.class.new(Utility.filter_values(obj.value), parameter_two)
            frac.hide_function_name = true
            obj.update(frac)
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            frac = self.class.new(nil, Utility.filter_values(obj.value))
            frac.hide_function_name = true
            obj.update(frac)
          end
        end

        def choose_frac
          first_value = unicodemath_parens(parameter_one) if parameter_one
          second_value = unicodemath_parens(parameter_two) if parameter_two
          "#{first_value}⒞#{second_value}"
        end

        protected

        def fpr_element
          fpr_element = Utility.ox_element("fPr", namespace: "m")
          if options
            attributes = { "m:val":  attr_value }
            fpr_element << Utility.ox_element("type", namespace: "m", attributes: attributes)
          end
          fpr_element << Utility.pr_element("ctrl", true, namespace: "m")
        end

        def attr_value
          if options[:linethickness] == "0"
            "noBar"
          else
            options[:bevelled] == 'true' ? 'skw' : "bar"
          end
        end

        def unicodemath_fraction
          frac_array = [parameter_one.value.to_i, parameter_two.value.to_i]
          UnicodeMath::Constants::UNICODE_FRACTIONS.key(frac_array)
        end
      end
    end
  end
end
