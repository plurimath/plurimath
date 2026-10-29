# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Renders a Formatter result (FormattedNotation, FormattedNumber, or
      # String) into a MathML element tree. Number delegates to this so the
      # model does not carry format-specific XML construction.
      module MathmlRenderer
        module_function

        def render(result)
          case result
          when FormattedNotation then render_notation(result)
          when FormattedNumber
            result.base_notation.semantic? ? render_semantic_base(result) : plain_element(result)
          else
            plain_element(result)
          end
        end

        def render_notation(notation)
          return plain_element(notation) if notation.notation_style == :e

          coeff = plain_element(notation.coefficient)
          times = XmlHelper.ox_element("mo") << notation.times_symbol.to_s
          base_el = XmlHelper.ox_element("mn") << "10"
          exp_el = XmlHelper.ox_element("mn") << notation.formatted_exponent
          sup = XmlHelper.ox_element("msup")
          XmlHelper.update_nodes(sup, [base_el, exp_el])
          row = XmlHelper.ox_element("mrow")
          XmlHelper.update_nodes(row, [coeff, times, sup])
          row
        end

        def render_semantic_base(formatted)
          digits = XmlHelper.ox_element("mn") << formatted.digits_string
          base_el = XmlHelper.ox_element("mn") << formatted.base_notation.base.to_s
          sub = XmlHelper.ox_element("msub")
          XmlHelper.update_nodes(sub, [digits, base_el])

          return sub unless formatted.sign_text

          sign_el = XmlHelper.ox_element("mo") << formatted.sign_text
          row = XmlHelper.ox_element("mrow")
          XmlHelper.update_nodes(row, [sign_el, sub])
          row
        end

        def plain_element(result)
          XmlHelper.ox_element("mn") << result.to_s
        end
      end
    end
  end
end
