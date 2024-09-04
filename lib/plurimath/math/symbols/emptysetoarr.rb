module Plurimath
  module Math
    module Symbols
      class Emptysetoarr < Symbol
        INPUT = {
          unicodemath: [["&#x29b3;"], parsing_wrapper(["emptysetoarr"], lang: :unicode)],
          asciimath: [["&#x29b3;"], parsing_wrapper(["emptysetoarr"], lang: :asciimath)],
          mathml: ["&#x29b3;"],
          latex: [["emptysetoarr", "&#x29b3;"]],
          omml: ["&#x29b3;"],
          html: ["&#x29b3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\emptysetoarr"
        end

        def to_asciimath(**)
          parsing_wrapper("emptysetoarr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b3;"
        end

        def to_html(**)
          "&#x29b3;"
        end
      end
    end
  end
end
