# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Ul < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one.to_asciimath(options: options)})" if parameter_one
          "underline#{first_value}"
        end

        def to_latex(options:)
          first_value = "{#{parameter_one.to_latex(options: options)}}" if parameter_one
          "\\underline#{first_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mo_tag = ox_element("mo") << "&#x332;"
          return mo_tag unless parameter_one

          munder_tag = ox_element("munder")
          munder_tag.set_attr(attributes) if attributes && !attributes.empty?
          Utility.update_nodes(
            munder_tag,
            [
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              mo_tag,
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("&#x332;", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accentunder]
            groupchr_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new("&#x332;")
            Underset.new(parameter_one, symbol).to_omml_without_math_tag(true, options: options)
          end
        end

        def to_unicodemath(options:)
          "▁#{unicodemath_parens(parameter_one, options: options)}"
        end

        def class_name
          "underline"
        end

        def swap_class
          Bar.new(parameter_one, attributes)
        end

        protected

        def groupchr_tag(display_style, options:)
          groupchr = Utility.ox_element("groupChr", namespace: "m")
          groupchrpr = Utility.ox_element("groupChrPR", namespace: "m")
          chr = Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "_" })
          pos = Utility.ox_element("pos", namespace: "m", attributes: { "m:val": "bot" })
          Utility.update_nodes(groupchrpr, [chr, pos])
          Utility.update_nodes(
            groupchr,
            [
              groupchrpr,
              omml_parameter(parameter_one, display_style, tag_name: "e", namespace: "m", options: options),
            ],
          )
        end
      end

      Underline = Ul
    end
  end
end
