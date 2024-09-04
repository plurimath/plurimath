module Plurimath
  module Math
    module Symbols
      class Rvert < Symbol
        INPUT = {
          unicodemath: [["&#x2225;"], parsing_wrapper(["parallel", "lVert", "rVert"], lang: :unicode)],
          asciimath: [["&#x2225;"], parsing_wrapper(["parallel", "lVert", "rVert"], lang: :asciimath)],
          mathml: ["&#x2225;"],
          latex: [["parallel", "lVert", "rVert", "&#x2225;"]],
          omml: ["&#x2225;"],
          html: ["&#x2225;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rVert"
        end

        def to_asciimath(**)
          parsing_wrapper("rVert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2225;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2225;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2225;"
        end

        def to_html(**)
          "&#x2225;"
        end
      end
    end
  end
end
