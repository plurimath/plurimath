module Plurimath
  module Math
    module Symbols
      class Lesges < Symbol
        INPUT = {
          unicodemath: [["&#x2a93;"], parsing_wrapper(["lesges"], lang: :unicode)],
          asciimath: [["&#x2a93;"], parsing_wrapper(["lesges"], lang: :asciimath)],
          mathml: ["&#x2a93;"],
          latex: [["lesges", "&#x2a93;"]],
          omml: ["&#x2a93;"],
          html: ["&#x2a93;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesges"
        end

        def to_asciimath(**)
          parsing_wrapper("lesges", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a93;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a93;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a93;"
        end

        def to_html(**)
          "&#x2a93;"
        end
      end
    end
  end
end
