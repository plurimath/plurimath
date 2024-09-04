module Plurimath
  module Math
    module Symbols
      class Vartriangleleft < Symbol
        INPUT = {
          unicodemath: [["vartriangleleft", "&#x22b2;"]],
          asciimath: [["&#x22b2;"], parsing_wrapper(["vartriangleleft"], lang: :asciimath)],
          mathml: ["&#x22b2;"],
          latex: [["vartriangleleft", "&#x22b2;"]],
          omml: ["&#x22b2;"],
          html: ["&#x22b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vartriangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("vartriangleleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b2;"
        end

        def to_html(**)
          "&#x22b2;"
        end
      end
    end
  end
end
