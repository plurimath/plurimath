module Plurimath
  module Math
    module Symbols
      class Dbkarow < Symbol
        INPUT = {
          unicodemath: [["&#x290f;"], parsing_wrapper(["dbkarow"], lang: :unicode)],
          asciimath: [["&#x290f;"], parsing_wrapper(["dbkarow"], lang: :asciimath)],
          mathml: ["&#x290f;"],
          latex: [["dbkarow", "&#x290f;"]],
          omml: ["&#x290f;"],
          html: ["&#x290f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dbkarow"
        end

        def to_asciimath(**)
          parsing_wrapper("dbkarow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290f;"
        end

        def to_html(**)
          "&#x290f;"
        end
      end
    end
  end
end
