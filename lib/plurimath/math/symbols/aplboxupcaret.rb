module Plurimath
  module Math
    module Symbols
      class Aplboxupcaret < Symbol
        INPUT = {
          unicodemath: [["&#x2353;"], parsing_wrapper(["APLboxupcaret"], lang: :unicode)],
          asciimath: [["&#x2353;"], parsing_wrapper(["APLboxupcaret"], lang: :asciimath)],
          mathml: ["&#x2353;"],
          latex: [["APLboxupcaret", "&#x2353;"]],
          omml: ["&#x2353;"],
          html: ["&#x2353;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLboxupcaret"
        end

        def to_asciimath(**)
          parsing_wrapper("APLboxupcaret", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2353;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2353;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2353;"
        end

        def to_html(**)
          "&#x2353;"
        end
      end
    end
  end
end
