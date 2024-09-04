module Plurimath
  module Math
    module Symbols
      class Quad < Symbol
        INPUT = {
          unicodemath: ["&#xa0;&#xa0;", "&#x2001;", "quad"],
          asciimath: ["&#xa0;&#xa0;", "&#x2001;", "quad"],
          mathml: ["&#xa0;&#xa0;", "&#x2001;"],
          latex: ["&#xa0;&#xa0;", "&#x2001;", "quad"],
          omml: ["&#xa0;&#xa0;", "&#x2001;"],
          html: ["&#xa0;&#xa0;", "&#x2001;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\quad"
        end

        def to_asciimath(**)
          "quad"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa0;&#xa0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa0;&#xa0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa0;&#xa0;"
        end

        def to_html(**)
          "&#xa0;&#xa0;"
        end
      end
    end
  end
end
