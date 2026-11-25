# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Right
        # Specialized tree writers load on first display use.
        module DisplayTreeMethods
          def to_asciimath_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{latex_paren}\" right\n"
          end

          def to_latex_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{latex_paren}\" right\n"
          end

          def to_mathml_math_zone(spacing = "", _, _, **)
            mo_tag = (XmlHelper.ox_element("mo") << right_paren)
            "#{spacing}\"#{dump_ox_nodes(mo_tag).gsub(/\s+/, '')}\" right\n"
          end

          def to_omml_math_zone(spacing = "", _, _, **)
            t_tag = (XmlHelper.ox_element("t", namespace: "m") << right_paren)
            "#{spacing}\"#{dump_ox_nodes(t_tag).gsub(/\s+/, '')}\" right\n"
          end

          def to_unicodemath_math_zone(spacing = "", _, _, **)
            "#{spacing}\"#{parameter_one}\" right\n"
          end
        end
      end
    end
  end
end
