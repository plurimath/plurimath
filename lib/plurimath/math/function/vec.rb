# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Vec < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_mathml_without_math_tag(intent, options:)
          mover = ox_element("mover")
          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options)
          mover[:accent] = attributes[:accent] if attributes && attributes[:accent]
          Utility.update_nodes(
            mover,
            [
              first_value,
              Utility.ox_element("mo") << "&#x2192;",
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("&#x2192;", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accent]
            acc_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new("→")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true, options: options)
          end
        end

        def to_unicodemath(options:)
          "#{unicodemath_parens(parameter_one, options: options)}⃗"
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_latex(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_mathml(self, options: options)}\" overset\n",
            "#{new_spacing}|_ \"<mo>&#x2192;</mo>\" base\n",
          ]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_omml(self, display_style, options: options)}\" overset\n",
            "#{new_spacing}|_ \"<m:t>&#x2192;</m:t>\" base\n",
          ]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "supscript", additional_space: "|  |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        protected

        def acc_tag(display_style, options:)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "→" }))
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
