module Plurimath
  module Math
    module Symbols
      class Diamondleftarrowbar < Symbol
        INPUT = {
          unicodemath: [["&#x291f;"], parsing_wrapper(["diamondleftarrowbar"], lang: :unicode)],
          asciimath: [["&#x291f;"], parsing_wrapper(["diamondleftarrowbar"], lang: :asciimath)],
          mathml: ["&#x291f;"],
          latex: [["diamondleftarrowbar", "&#x291f;"]],
          omml: ["&#x291f;"],
          html: ["&#x291f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondleftarrowbar"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondleftarrowbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x291f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x291f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x291f;"
        end

        def to_html(**)
          "&#x291f;"
        end
      end
    end
  end
end
