module Plurimath
  module Math
    module Symbols
      class Bigoplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a01;"], parsing_wrapper(["bigoplus"], lang: :unicode)],
          asciimath: [["&#x2a01;"], parsing_wrapper(["bigoplus"], lang: :asciimath)],
          mathml: ["&#x2a01;"],
          latex: [["bigoplus", "&#x2a01;"]],
          omml: ["&#x2a01;"],
          html: ["&#x2a01;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigoplus"
        end

        def to_asciimath(**)
          parsing_wrapper("bigoplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a01;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a01;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a01;"
        end

        def to_html(**)
          "&#x2a01;"
        end
      end
    end
  end
end
