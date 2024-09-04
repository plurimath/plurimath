module Plurimath
  module Math
    module Symbols
      class Curvearrowrightminus < Symbol
        INPUT = {
          unicodemath: [["&#x293c;"], parsing_wrapper(["curvearrowrightminus"], lang: :unicode)],
          asciimath: [["&#x293c;"], parsing_wrapper(["curvearrowrightminus"], lang: :asciimath)],
          mathml: ["&#x293c;"],
          latex: [["curvearrowrightminus", "&#x293c;"]],
          omml: ["&#x293c;"],
          html: ["&#x293c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curvearrowrightminus"
        end

        def to_asciimath(**)
          parsing_wrapper("curvearrowrightminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293c;"
        end

        def to_html(**)
          "&#x293c;"
        end
      end
    end
  end
end
