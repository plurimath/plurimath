module Plurimath
  module Math
    module Symbols
      class Smallblacktriangleleft < Symbol
        INPUT = {
          unicodemath: [["&#x25c2;"], parsing_wrapper(["smallblacktriangleleft"], lang: :unicode)],
          asciimath: [["&#x25c2;"], parsing_wrapper(["smallblacktriangleleft"], lang: :asciimath)],
          mathml: ["&#x25c2;"],
          latex: [["smallblacktriangleleft", "&#x25c2;"]],
          omml: ["&#x25c2;"],
          html: ["&#x25c2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smallblacktriangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("smallblacktriangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c2;"
        end

        def to_html(**)
          "&#x25c2;"
        end
      end
    end
  end
end
