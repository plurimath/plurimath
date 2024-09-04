module Plurimath
  module Math
    module Symbols
      class Leftwavearrow < Symbol
        INPUT = {
          unicodemath: [["leftwavearrow", "&#x219c;"]],
          asciimath: [["&#x219c;"], parsing_wrapper(["leftwavearrow"], lang: :asciimath)],
          mathml: ["&#x219c;"],
          latex: [["leftwavearrow", "&#x219c;"]],
          omml: ["&#x219c;"],
          html: ["&#x219c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftwavearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftwavearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x219c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x219c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x219c;"
        end

        def to_html(**)
          "&#x219c;"
        end
      end
    end
  end
end
