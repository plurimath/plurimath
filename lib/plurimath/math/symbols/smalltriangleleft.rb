module Plurimath
  module Math
    module Symbols
      class Smalltriangleleft < Symbol
        INPUT = {
          unicodemath: [["&#x25c3;"], parsing_wrapper(["smalltriangleleft"], lang: :unicode)],
          asciimath: [["&#x25c3;"], parsing_wrapper(["smalltriangleleft"], lang: :asciimath)],
          mathml: ["&#x25c3;"],
          latex: [["smalltriangleleft", "&#x25c3;"]],
          omml: ["&#x25c3;"],
          html: ["&#x25c3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smalltriangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("smalltriangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c3;"
        end

        def to_html(**)
          "&#x25c3;"
        end
      end
    end
  end
end
