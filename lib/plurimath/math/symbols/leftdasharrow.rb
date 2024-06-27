module Plurimath
  module Math
    module Symbols
      class Leftdasharrow < Symbol
        INPUT = {
          unicodemath: [["curvearrowleft", "&#x21e0;"], parsing_wrapper(["dashleftarrow", "leftdasharrow"])],
          asciimath: [["&#x21e0;"], parsing_wrapper(["curvearrowleft", "dashleftarrow", "leftdasharrow"])],
          mathml: ["&#x21e0;"],
          latex: [["dashleftarrow", "leftdasharrow", "&#x21e0;"], parsing_wrapper(["curvearrowleft"])],
          omml: ["&#x21e0;"],
          html: ["&#x21e0;"],
        }.freeze

        # output methods
        def to_latex
          "\\dashleftarrow"
        end

        def to_asciimath
          parsing_wrapper("leftdasharrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21e0;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x21e0;"
        end

        def to_omml_without_math_tag(_)
          "&#x21e0;"
        end

        def to_html
          "&#x21e0;"
        end
      end
    end
  end
end
