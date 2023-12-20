# frozen_string_literal: true

require_relative "ternary_function"
module Plurimath
  module Math
    module Function
      class Multiscript < TernaryFunction
        FUNCTION = {
          name: "multiscript",
          first_value: "base",
          second_value: "subscript",
          third_value: "supscript",
        }.freeze

        def to_asciimath
          subscript = "_(#{parameter_two&.map(&:to_asciimath).join})" unless valid_value_exist?(parameter_two)
          supscript = "^(#{parameter_three&.map(&:to_asciimath).join})" unless valid_value_exist?(parameter_three)
          prescript = "\\ #{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_asciimath}"
        end

        def to_latex
          subscript = "_{#{parameter_two&.map(&:to_latex).join}}" unless valid_value_exist?(parameter_two)
          supscript = "^{#{parameter_three&.map(&:to_latex).join}}" unless valid_value_exist?(parameter_three)
          prescript = "{}#{subscript}#{supscript}" if subscript || supscript
          "#{prescript}#{parameter_one&.to_latex}"
        end

        def to_mathml_without_math_tag
          mprescript = ox_element("mprescripts") if (parameter_two || parameter_three)
          Utility.update_nodes(
            ox_element("mmultiscripts"),
            [
              parameter_one&.mmultiscript,
              mprescript,
              validate_mathml_fields(prescripts),
            ]
          )
        end

        def to_omml_without_math_tag(display_style)
          Utility.update_nodes(
            ox_element("sPre", namespace: "m"),
            [
              omml_parameter(parameter_one, display_style, tag_name: "e"),
              omml_parameter(parameter_two, display_style, tag_name: "sub"),
              omml_parameter(parameter_three, display_style, tag_name: "sup"),
            ],
          )
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three)
            )
            self.parameter_two = nil
            self.parameter_three = nil
            return
          end

          parameter_two.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(nil, Utility.filter_values(obj.value), parameter_three)
            )
            self.parameter_three = nil
          end
        end

        private

        def prescripts
          Array(parameter_two)&.zip(Array(parameter_three))&.flatten&.compact
        end

        def valid_value_exist?(field)
          field&.empty? || field&.all?(None)
        end
      end
    end
  end
end
