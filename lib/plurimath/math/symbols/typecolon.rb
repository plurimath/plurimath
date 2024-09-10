module Plurimath
  module Math
    module Symbols
      class Typecolon < Symbol
        INPUT = {
          unicodemath: [["&#x2982;"], parsing_wrapper(["typecolon"], lang: :unicode)],
          asciimath: [["&#x2982;"], parsing_wrapper(["typecolon"], lang: :asciimath)],
          mathml: ["&#x2982;"],
          latex: [["typecolon", "&#x2982;"]],
          omml: ["&#x2982;"],
          html: ["&#x2982;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\typecolon"
        end

        def to_asciimath(**)
          parsing_wrapper("typecolon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2982;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2982;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2982;"
        end

        def to_html(**)
          "&#x2982;"
        end
      end
    end
  end
end
