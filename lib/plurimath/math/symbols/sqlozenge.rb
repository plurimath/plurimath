module Plurimath
  module Math
    module Symbols
      class Sqlozenge < Symbol
        INPUT = {
          unicodemath: [["&#x2311;"], parsing_wrapper(["wasylozenge", "sqlozenge"], lang: :unicode)],
          asciimath: [["&#x2311;"], parsing_wrapper(["wasylozenge", "sqlozenge"], lang: :asciimath)],
          mathml: ["&#x2311;"],
          latex: [["wasylozenge", "sqlozenge", "&#x2311;"]],
          omml: ["&#x2311;"],
          html: ["&#x2311;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wasylozenge"
        end

        def to_asciimath(**)
          parsing_wrapper("sqlozenge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2311;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2311;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2311;"
        end

        def to_html(**)
          "&#x2311;"
        end
      end
    end
  end
end
