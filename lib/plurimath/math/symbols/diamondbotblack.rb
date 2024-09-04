module Plurimath
  module Math
    module Symbols
      class Diamondbotblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b19;"], parsing_wrapper(["diamondbotblack"], lang: :unicode)],
          asciimath: [["&#x2b19;"], parsing_wrapper(["diamondbotblack"], lang: :asciimath)],
          mathml: ["&#x2b19;"],
          latex: [["diamondbotblack", "&#x2b19;"]],
          omml: ["&#x2b19;"],
          html: ["&#x2b19;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondbotblack"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondbotblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b19;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b19;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b19;"
        end

        def to_html(**)
          "&#x2b19;"
        end
      end
    end
  end
end
