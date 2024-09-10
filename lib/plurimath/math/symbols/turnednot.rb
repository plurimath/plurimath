module Plurimath
  module Math
    module Symbols
      class Turnednot < Symbol
        INPUT = {
          unicodemath: [["&#x2319;"], parsing_wrapper(["turnednot"], lang: :unicode)],
          asciimath: [["&#x2319;"], parsing_wrapper(["turnednot"], lang: :asciimath)],
          mathml: ["&#x2319;"],
          latex: [["turnednot", "&#x2319;"]],
          omml: ["&#x2319;"],
          html: ["&#x2319;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\turnednot"
        end

        def to_asciimath(**)
          parsing_wrapper("turnednot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2319;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2319;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2319;"
        end

        def to_html(**)
          "&#x2319;"
        end
      end
    end
  end
end
