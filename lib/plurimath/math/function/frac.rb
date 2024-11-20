# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Frac < BinaryFunction
        include Mathml::Utility

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

        def to_asciimath(options:)
          first_value = "(#{parameter_one&.to_asciimath(options: options)})" if parameter_one
          second_value = "(#{parameter_two&.to_asciimath(options: options)})" if parameter_two
          "frac#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          tag_name = hide_function_name ? "mrow" : "mfrac"
          mathml_value = [
            parameter_one&.to_mathml_without_math_tag(intent, options: options),
            parameter_two&.to_mathml_without_math_tag(intent, options: options),
          ]
          frac_tag = ox_element(tag_name)
          frac_tag.set_attr(self.options.reject { |opt| opt == :choose }) if tag_name == "mfrac" && self.options
          Utility.update_nodes(frac_tag, mathml_value)
          update_derivative(frac_tag, mathml_value[0], mathml_value[1]) if intent
          intentify(frac_tag, intent, func_name: :frac, options: intent_names)
        end

        def to_latex(options:)
          first_value = parameter_one&.to_latex(options: options)
          two_value = parameter_two&.to_latex(options: options)
          "\\frac{#{first_value}}{#{two_value}}"
        end

        def to_omml_without_math_tag(display_style, options:)
          f_element   = Utility.ox_element("f", namespace: "m")
          Utility.update_nodes(
            f_element,
            [
              fpr_element,
              omml_parameter(parameter_one, display_style, tag_name: "num", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "den", options: options),
            ],
          )
        end

        def to_unicodemath(options:)
          return unicodemath_fraction if self.options&.dig(:unicodemath_fraction)

          first_value = unicodemath_parens(parameter_one, options: options) if parameter_one
          second_value = unicodemath_parens(parameter_two, options: options) if parameter_two
          return "#{first_value}/#{second_value}" unless self.options

          return "#{first_value}¦#{second_value}" if self.options && self.options.key?(:linethickness)
          return "#{parameter_one.to_unicodemath(options: options)}⊘#{parameter_two.to_unicodemath(options: options)}" if self.options && self.options.key?(:displaystyle)
          "#{first_value}∕#{second_value}" if self.options && self.options.key?(:ldiv)
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

        def choose_frac(options:)
          first_value = unicodemath_parens(parameter_one, options: options) if parameter_one
          second_value = unicodemath_parens(parameter_two, options: options) if parameter_two
          "#{first_value}⒞#{second_value}"
        end

        def intent_names
          {
            derivative: ":derivative",
            partial_derivative: ":partial-derivative",
          }
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

        def update_derivative(tag, num, den)
          return if %w[mi mo mn].include?(num&.name)

          intent = num.is_a?(::Array) ? num.first["intent"] : num&.nodes&.first["intent"]
          return unless intent
          return unless intent.start_with?(":derivative") && intent.end_with?(",)")

          num.nodes.first["intent"] = num.nodes.first["intent"].gsub(/,\)$/, ",#{validate_derivative(den.nodes)})")
        end

        def validate_derivative(den_nodes)
          str = ""
          if den_nodes.first.name == "mi"
            node = den_nodes[1]
            if %w[msub msup].include?(node.name)
              case node.nodes.first.name
              when "mi"
                str += Utility.html_entity_to_unicode(node.nodes.first.nodes.first)
              when "mrow"
                node.nodes.first.nodes.each do |element|
                  break unless element.name == "mi"

                  str += Utility.html_entity_to_unicode(element.nodes.first)
                end
              end
            end
          end
          str
        end
      end
    end
  end
end
