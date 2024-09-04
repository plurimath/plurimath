module Plurimath
  module Math
    module Symbols
      class Vectimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a2f;"], parsing_wrapper(["vectimes"], lang: :unicode)],
          asciimath: [["&#x2a2f;"], parsing_wrapper(["vectimes"], lang: :asciimath)],
          mathml: ["&#x2a2f;"],
          latex: [["vectimes", "&#x2a2f;"]],
          omml: ["&#x2a2f;"],
          html: ["&#x2a2f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vectimes"
        end

        def to_asciimath(**)
          parsing_wrapper("vectimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a2f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a2f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a2f;"
        end

        def to_html(**)
          "&#x2a2f;"
        end
      end
    end
  end
end
