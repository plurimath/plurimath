module Plurimath
  module Math
    module Symbols
      class Circleonleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b30;"], parsing_wrapper(["circleonleftarrow"], lang: :unicode)],
          asciimath: [["&#x2b30;"], parsing_wrapper(["circleonleftarrow"], lang: :asciimath)],
          mathml: ["&#x2b30;"],
          latex: [["circleonleftarrow", "&#x2b30;"]],
          omml: ["&#x2b30;"],
          html: ["&#x2b30;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circleonleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("circleonleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b30;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b30;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b30;"
        end

        def to_html(**)
          "&#x2b30;"
        end
      end
    end
  end
end
