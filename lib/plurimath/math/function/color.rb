# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        autoload :DisplayTreeMethods, "plurimath/math/function/color/display_tree_methods"

        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "An expression rendered in a specified color."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/mstyle"
        EXAMPLE = -> { new(sym("red"), sym("x")) }
        CATALOG_FORMAT_LIMITATIONS = {
          omml: {
            status: :limited,
            notes: ["Color styling is omitted; only the expression is emitted."],
          },
        }.freeze
        # --- end catalog documentation ---

        node_fields :parameter_one, :parameter_two,
                    scalars: { hide_function_name: :boolean }, hashes: %i[options]

        FUNCTION = {
          name: "color",
          first_value: "mathcolor",
          second_value: "text",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one&.to_asciimath(options: options)&.gsub(
            /\s/, ''
          )})"
          second_value = "(#{parameter_two&.to_asciimath(options: options)})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            XmlHelper.ox_element(
              "mrow",
              attributes: mathml_options,
            ),
            [parameter_two&.to_mathml_without_math_tag(intent,
                                                       options: options)],
          )
        end

        def to_latex(options:)
          first_value = parameter_one&.to_asciimath(options: options)&.gsub(
            /\s/, ""
          )
          second_value = parameter_two&.to_latex(options: options)
          "{\\#{class_name}{#{first_value}} #{second_value}}"
        end

        def to_omml_without_math_tag(display_style, options:)
          Array(parameter_two.insert_t_tag(display_style, options: options))
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:,
options:)
          Color.include(DisplayTreeMethods) unless Color < DisplayTreeMethods
          super
        end

        # The color is one value. AsciiMath reads color(red) as the
        # symbols r, e and d, which write back space-separated; drop the
        # spaces as #to_asciimath and the MathML attribute already do.
        def to_unicodemath(options:)
          color = parameter_one.to_unicodemath(options: options)&.gsub(/\s/, "")
          "#{color_symbol}(#{color}&#{parameter_two.to_unicodemath(options: options)})"
        end

        protected

        def color_symbol
          options&.dig(:backgroundcolor) ? "☁" : "✎"
        end

        def attr_key
          options&.dig(:backgroundcolor) ? :mathbackground : :mathcolor
        end

        def mathml_options
          return unless parameter_one

          color_options = {}
          color_options[attr_key] =
            parameter_one.to_asciimath(options: options)&.gsub(/\s/, "")&.gsub(
              '"', ""
            )
          color_options
        end
      end
    end
  end
end
