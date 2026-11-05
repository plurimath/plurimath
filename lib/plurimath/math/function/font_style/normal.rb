# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class FontStyle
        class Normal < FontStyle
          # --- Catalog documentation (see Plurimath::Documentation) ---
          DESCRIPTION = "Renders its argument in an upright (roman, non-italic) font."
          REFERENCE = "https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols"
          EXAMPLE = -> { new(sym("x")) }
          # --- end catalog documentation ---

          def initialize(parameter_one = nil,
                         parameter_two = "rm")
            super
          end

          def to_asciimath(options:)
            "rm(#{parameter_one&.to_asciimath(options: options)})"
          end

          def to_latex(options:)
            "\\mathrm{#{parameter_one&.to_latex(options: options)}}"
          end

          def to_mathml_without_math_tag(intent, options:)
            XmlHelper.update_nodes(
              XmlHelper.ox_element(
                "mstyle",
                attributes: { mathvariant: "normal" },
              ),
              [parameter_one&.to_mathml_without_math_tag(intent,
                                                         options: options)],
            )
          end

          def to_omml_without_math_tag(display_style, options:)
            font_styles(display_style, sty: "p", options: options)
          end

          # In a unit, a symbol of more than one character is written as
          # quoted text, \mup"kg": UnicodeMath reads \mupkg as an upright k
          # followed by g. One-letter units keep the \mupg form.
          def to_unicodemath(options:)
            return super unless unicodemath_unit_text?(options)

            text = Text.new(parameter_one.value)
            "#{font_family(unicode: true)}#{text.to_unicodemath(options: options)}"
          end

          private

          def unicodemath_unit_text?(options)
            return false unless options.is_a?(Hash) && options[:unicodemath_unit]
            return false unless parameter_one.instance_of?(Math::Symbols::Symbol)

            value = parameter_one.value.to_s
            !value.start_with?("\\") &&
              Utility.html_entity_to_unicode(value).length > 1
          end
        end
      end
    end
  end
end
