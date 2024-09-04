module Plurimath
  module Math
    module Symbols
      class Setminus < Symbol
        INPUT = {
          unicodemath: [["setminus", "&#x2216;"], parsing_wrapper(["smallsetminus"], lang: :unicode)],
          asciimath: [["&#x2216;"], parsing_wrapper(["setminus", "smallsetminus"], lang: :asciimath)],
          mathml: ["&#x2216;"],
          latex: [["smallsetminus", "&#x2216;"], parsing_wrapper(["setminus"], lang: :latex)],
          omml: ["&#x2216;"],
          html: ["&#x2216;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smallsetminus"
        end

        def to_asciimath(**)
          parsing_wrapper("setminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2216;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2216;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2216;"
        end

        def to_html(**)
          "&#x2216;"
        end
      end
    end
  end
end
