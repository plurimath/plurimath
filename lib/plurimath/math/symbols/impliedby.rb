module Plurimath
  module Math
    module Symbols
      class Impliedby < Symbol
        INPUT = {
          unicodemath: [["Longleftarrow", "&#x27f8;"], parsing_wrapper(["impliedby"])],
          asciimath: [["&#x27f8;"], parsing_wrapper(["Longleftarrow", "impliedby"])],
          mathml: ["&#x27f8;"],
          latex: [["Longleftarrow", "impliedby", "&#x27f8;"]],
          omml: ["&#x27f8;"],
          html: ["&#x27f8;"],
        }.freeze

        # output methods
        def to_latex
          "\\Longleftarrow"
        end

        def to_asciimath
          parsing_wrapper("impliedby")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27f8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27f8;"
        end

        def to_omml_without_math_tag(_)
          "&#x27f8;"
        end

        def to_html
          "&#x27f8;"
        end
      end
    end
  end
end
