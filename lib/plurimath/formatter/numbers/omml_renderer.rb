# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Renders a Formatter result (FormattedNotation, FormattedNumber, or
      # String) into an OMML element tree. Number delegates to this so the
      # model does not carry format-specific XML construction.
      module OmmlRenderer
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

          sup_struct = XmlHelper.ox_element("sSup", namespace: "m")
          subpr = XmlHelper.ox_element("sSupPr", namespace: "m")
          subpr << XmlHelper.pr_element("ctrl", true, namespace: "m")

          coeff_run = text_run(notation.coefficient.to_s)
          times_run = text_run(" #{notation.times_symbol} ")
          base_run = text_run("10")
          exp_run = text_run(notation.formatted_exponent)

          e_el = XmlHelper.ox_element("e", namespace: "m")
          XmlHelper.update_nodes(e_el, [coeff_run, times_run, base_run])

          sup_el = XmlHelper.ox_element("sup", namespace: "m")
          XmlHelper.update_nodes(sup_el, [exp_run])

          XmlHelper.update_nodes(sup_struct, [subpr, e_el, sup_el])
          sup_struct
        end

        def render_semantic_base(formatted)
          sub_struct = XmlHelper.ox_element("sSub", namespace: "m")
          subpr = XmlHelper.ox_element("sSubPr", namespace: "m")
          subpr << XmlHelper.pr_element("ctrl", true, namespace: "m")

          digits_with_sign = "#{formatted.sign_text}#{formatted.digits_string}"
          base_run = text_run(digits_with_sign)
          sub_run = text_run(formatted.base_notation.base.to_s)

          e_el = XmlHelper.ox_element("e", namespace: "m")
          XmlHelper.update_nodes(e_el, [base_run])

          sub_el = XmlHelper.ox_element("sub", namespace: "m")
          XmlHelper.update_nodes(sub_el, [sub_run])

          XmlHelper.update_nodes(sub_struct, [subpr, e_el, sub_el])
          sub_struct
        end

        def plain_element(result)
          XmlHelper.ox_element("t", namespace: "m") << result.to_s
        end

        def text_run(text)
          run = XmlHelper.ox_element("r", namespace: "m")
          run << (XmlHelper.ox_element("t", namespace: "m") << text)
        end
      end
    end
  end
end
