module Plurimath
  module Math
    module Symbols
      class Vdots < Symbol
        INPUT = {
          unicodemath: [["vdots", "&#x22ee;"]],
          asciimath: [["vdots", "&#x22ee;"]],
          mathml: ["&#x22ee;"],
          latex: [["vdots", "&#x22ee;"]],
          omml: ["&#x22ee;"],
          html: ["&#x22ee;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vdots"
        end

        def to_asciimath(**)
          "vdots"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ee;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x22ee;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ee;"
        end

        def to_html(**)
          "&#x22ee;"
        end
      end
    end
  end
end
