# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Hat < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath
          first_value = "(#{parameter_one.to_asciimath})" if parameter_one
          "hat#{first_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\hat#{first_value}"
        end

        def to_mathml_without_math_tag
          mo_tag = (Utility.ox_element("mo") << "^")
          return mo_tag unless parameter_one

          mover_tag = Utility.ox_element("mover")
          mover_tag.attributes.merge!(attributes) if attributes && !attributes.empty?
          Utility.update_nodes(
            mover_tag,
            [
              parameter_one&.to_mathml_without_math_tag,
              mo_tag,
            ],
          )
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style)
          return r_element("^", rpr_tag: false) unless parameter_one
          return omml_value(display_style) if hide_function_name

          if attributes && attributes[:accent]
            accent_tag(display_style)
          else
            symbol = Symbol.new("&#x302;") unless hide_function_name
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(display_style)
          end
        end

        def to_unicodemath
          "#{unicodemath_parens(parameter_one)}̂"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Overset.new(Utility.filter_values(obj.value), nil),
            )
          end
        end

        protected

        def accent_tag(display_style)
          symbol  = "̂" unless hide_function_name
          acc_tag = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << (Utility.ox_element("chr", namespace: "m", attributes: { "m:val": symbol }))
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e", namespace: "m"),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
