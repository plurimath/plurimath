module Plurimath
  module Math
    module Symbols
      class Diamondrightblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b17;"], parsing_wrapper(["diamondrightblack"], lang: :unicode)],
          asciimath: [["&#x2b17;"], parsing_wrapper(["diamondrightblack"], lang: :asciimath)],
          mathml: ["&#x2b17;"],
          latex: [["diamondrightblack", "&#x2b17;"]],
          omml: ["&#x2b17;"],
          html: ["&#x2b17;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondrightblack"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondrightblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b17;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b17;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b17;"
        end

        def to_html(**)
          "&#x2b17;"
        end
      end
    end
  end
end
