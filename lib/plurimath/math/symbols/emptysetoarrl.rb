module Plurimath
  module Math
    module Symbols
      class Emptysetoarrl < Symbol
        INPUT = {
          unicodemath: [["&#x29b4;"], parsing_wrapper(["emptysetoarrl"], lang: :unicode)],
          asciimath: [["&#x29b4;"], parsing_wrapper(["emptysetoarrl"], lang: :asciimath)],
          mathml: ["&#x29b4;"],
          latex: [["emptysetoarrl", "&#x29b4;"]],
          omml: ["&#x29b4;"],
          html: ["&#x29b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\emptysetoarrl"
        end

        def to_asciimath(**)
          parsing_wrapper("emptysetoarrl", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b4;"
        end

        def to_html(**)
          "&#x29b4;"
        end
      end
    end
  end
end
