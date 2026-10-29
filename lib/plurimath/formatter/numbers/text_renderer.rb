# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Renders a Formatter result (FormattedNotation, FormattedNumber, or
      # String) into a plain-text format (LaTeX, AsciiMath, HTML, UnicodeMath).
      # For semantic base notation, each format's template lives in
      # BASE_TEMPLATES; adding a new text format is a one-line change there.
      # When the caller supplies an explicit base_prefix/base_postfix, the
      # literal prefix+postfix take precedence (no format-specific decoration).
      module TextRenderer
        # %<sign>s %<digits>s %<base>d — sign_text returns "" for positives
        # without explicit :plus, so interpolation collapses cleanly.
        BASE_TEMPLATES = {
          asciimath: "%<sign>s%<digits>s_(%<base>d)",
          unicodemath: "%<sign>s%<digits>s_(%<base>d)",
          latex: "%<sign>s\\mathrm{%<digits>s}_{%<base>d}",
          html: "%<sign>s%<digits>s<sub>%<base>d</sub>",
        }.freeze

        module_function

        def render(result, format)
          return result.to_s unless structured_number?(result)

          if result.base_notation.literal?
            result.to_s
          else
            render_semantic(result, format)
          end
        end

        def structured_number?(result)
          result.is_a?(FormattedNumber) && result.base_notation?
        end
        private_class_method :structured_number?

        def render_semantic(result, format)
          return result.to_s unless result.base_notation.semantic?

          template = BASE_TEMPLATES.fetch(format)
          format(template,
                 sign: result.sign_text.to_s,
                 digits: result.digits_string,
                 base: result.base_notation.base)
        end
        private_class_method :render_semantic
      end
    end
  end
end
