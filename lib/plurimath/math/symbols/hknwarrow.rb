module Plurimath
  module Math
    module Symbols
      class Hknwarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2923;"], parsing_wrapper(["hknwarrow"], lang: :unicode)],
          asciimath: [["&#x2923;"], parsing_wrapper(["hknwarrow"], lang: :asciimath)],
          mathml: ["&#x2923;"],
          latex: [["hknwarrow", "&#x2923;"]],
          omml: ["&#x2923;"],
          html: ["&#x2923;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hknwarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("hknwarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2923;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2923;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2923;"
        end

        def to_html(**)
          "&#x2923;"
        end
      end
    end
  end
end
