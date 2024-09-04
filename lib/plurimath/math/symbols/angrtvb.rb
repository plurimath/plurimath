module Plurimath
  module Math
    module Symbols
      class Angrtvb < Symbol
        INPUT = {
          unicodemath: [["angrtvb", "&#x22be;"], parsing_wrapper(["measuredrightangle"], lang: :unicode)],
          asciimath: [["&#x22be;"], parsing_wrapper(["angrtvb", "measuredrightangle"], lang: :asciimath)],
          mathml: ["&#x22be;"],
          latex: [["measuredrightangle", "&#x22be;"], parsing_wrapper(["angrtvb"], lang: :latex)],
          omml: ["&#x22be;"],
          html: ["&#x22be;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measuredrightangle"
        end

        def to_asciimath(**)
          parsing_wrapper("angrtvb", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22be;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22be;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22be;"
        end

        def to_html(**)
          "&#x22be;"
        end
      end
    end
  end
end
