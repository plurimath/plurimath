module Plurimath
  module Math
    module Symbols
      class Amalg < Symbol
        INPUT = {
          unicodemath: [["&#x2a3f;"], parsing_wrapper(["amalg"], lang: :unicode)],
          asciimath: [["&#x2a3f;"], parsing_wrapper(["amalg"], lang: :asciimath)],
          mathml: ["&#x2a3f;"],
          latex: [["amalg", "&#x2a3f;"]],
          omml: ["&#x2a3f;"],
          html: ["&#x2a3f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\amalg"
        end

        def to_asciimath(**)
          parsing_wrapper("amalg", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3f;"
        end

        def to_html(**)
          "&#x2a3f;"
        end
      end
    end
  end
end
