module Plurimath
  module Math
    module Symbols
      class Diamondleftblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b16;"], parsing_wrapper(["diamondleftblack"], lang: :unicode)],
          asciimath: [["&#x2b16;"], parsing_wrapper(["diamondleftblack"], lang: :asciimath)],
          mathml: ["&#x2b16;"],
          latex: [["diamondleftblack", "&#x2b16;"]],
          omml: ["&#x2b16;"],
          html: ["&#x2b16;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondleftblack"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondleftblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b16;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b16;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b16;"
        end

        def to_html(**)
          "&#x2b16;"
        end
      end
    end
  end
end
