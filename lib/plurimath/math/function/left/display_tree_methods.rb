# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Left
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{latex_paren}\" left\n"
          end

          def to_latex_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{latex_paren}\" left\n"
          end

          def to_mathml_math_zone(spacing = "", _, _, **)
            mo_tag = (XmlHelper.ox_element("mo") << left_paren)
            "#{spacing}\"#{dump_ox_nodes(mo_tag).gsub(/\s+/, '')}\" left\n"
          end

          def to_omml_math_zone(spacing = "", _, _, display_style:, **)
            t_tag = (XmlHelper.ox_element("t", namespace: "m") << left_paren)
            "#{spacing}\"#{dump_ox_nodes(t_tag).gsub(/\s+/, '')}\" left\n"
          end

          def to_unicodemath_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{parameter_one}\" left\n"
          end
        end
      end
    end
  end
end
