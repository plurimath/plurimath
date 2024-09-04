module Plurimath
  module Math
    module Symbols
      class Diamondleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x291d;"], parsing_wrapper(["diamondleftarrow"], lang: :unicode)],
          asciimath: [["&#x291d;"], parsing_wrapper(["diamondleftarrow"], lang: :asciimath)],
          mathml: ["&#x291d;"],
          latex: [["diamondleftarrow", "&#x291d;"]],
          omml: ["&#x291d;"],
          html: ["&#x291d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x291d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x291d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x291d;"
        end

        def to_html(**)
          "&#x291d;"
        end
      end
    end
  end
end
