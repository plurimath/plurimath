module Plurimath
  module Math
    module Symbols
      class Rel < Symbol
        INPUT = {
          unicodemath: [["leftrightarrow", "&#x2194;"], parsing_wrapper(["harr", "rel"], lang: :unicode)],
          asciimath: [["leftrightarrow", "harr", "&#x2194;"], parsing_wrapper(["rel"], lang: :asciimath)],
          mathml: ["&#x2194;"],
          latex: [["leftrightarrow", "rel", "&#x2194;"], parsing_wrapper(["harr"], lang: :latex)],
          omml: ["&#x2194;"],
          html: ["&#x2194;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rel", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2194;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2194;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2194;"
        end

        def to_html(**)
          "&#x2194;"
        end
      end
    end
  end
end
