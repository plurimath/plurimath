module Plurimath
  module Math
    module Symbols
      class Dotminus < Symbol
        INPUT = {
          unicodemath: [["dotminus", "&#x2238;"]],
          asciimath: [["&#x2238;"], parsing_wrapper(["dotminus"], lang: :asciimath)],
          mathml: ["&#x2238;"],
          latex: [["dotminus", "&#x2238;"]],
          omml: ["&#x2238;"],
          html: ["&#x2238;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dotminus"
        end

        def to_asciimath(**)
          parsing_wrapper("dotminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2238;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2238;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2238;"
        end

        def to_html(**)
          "&#x2238;"
        end
      end
    end
  end
end
