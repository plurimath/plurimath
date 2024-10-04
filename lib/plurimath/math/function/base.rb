# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Base < BinaryFunction
        include Mathml::Utility

        attr_accessor :options

        FUNCTION = {
          name: "subscript",
          first_value: "base",
          second_value: "script",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def ==(object)
          super(object) &&
            object.options == options
        end

        def to_asciimath(options:)
          first_value = parameter_one.to_asciimath(options: options) if parameter_one
          second_value = "_#{wrapped(parameter_two, options: options)}" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          tag_name = Utility::MUNDER_CLASSES.include?(parameter_one&.class_name) ? "under" : "sub"
          sub_tag = Utility.ox_element("m#{tag_name}")
          mathml_value = []
          mathml_value << validate_mathml_fields(parameter_one, intent, options: options)
          mathml_value << validate_mathml_fields(parameter_two, intent, options: options)
          Utility.update_nodes(sub_tag, mathml_value)
        end

        def to_latex(options:)
          first_value  = parameter_one.to_latex(options: options) if parameter_one
          first_value  = "{#{first_value}}" if parameter_one.is_a?(Formula)
          second_value = parameter_two.to_latex(options: options) if parameter_two
          "#{first_value}_{#{second_value}}"
        end

        def to_html(options:)
          first_value  = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<sub>#{parameter_two.to_html(options: options)}</sub>" if parameter_two
          "#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag(display_style, options:)
          ssub_element  = Utility.ox_element("sSub", namespace: "m")
          subpr_element = Utility.ox_element("sSubPr", namespace: "m")
          subpr_element << Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(
            ssub_element,
            [
              subpr_element,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
              omml_parameter(parameter_two, display_style, tag_name: "sub", options: options),
            ],
          )
          [ssub_element]
        end

        def to_unicodemath(options:)
          first_value = parameter_one.to_unicodemath(options: options) if parameter_one
          second_value = if parameter_two.is_a?(self.class)
            "_#{size_overrides}#{parameter_two.to_unicodemath(options: options)}"
          elsif parameter_two&.mini_sized?
            parameter_two.to_unicodemath(options: options)
          elsif parameter_two.nil?
            "()"
          else
            "_#{size_overrides}#{unicodemath_parens(parameter_two, options: options)}"
          end
          "#{first_value}#{second_value}"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two))
            self.parameter_two = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value)))
          end
        end

        def new_nary_function(fourth_value)
          Nary.new(parameter_one, parameter_two, nil, fourth_value)
        end

        def is_nary_function?
          parameter_one.is_nary_function? || parameter_one.is_nary_symbol?
        end

        protected

        def size_overrides
          return if options.nil? || options&.empty?

          "Ⅎ#{UnicodeMath::Constants::SIZE_OVERRIDES_SYMBOLS.invert[options[:size]]}" if options[:size]
        end

        def unicodemath_parens(field, options:)
          return "〖#{field.to_unicodemath(options: options)}〗" unless self.options.nil? || self.options&.empty?

          super(field, options: options)
        end
      end
    end
  end
end
