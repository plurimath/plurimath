module Plurimath
  module Math
    module Symbols
      class Diamondtopblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b18;"], parsing_wrapper(["diamondtopblack"], lang: :unicode)],
          asciimath: [["&#x2b18;"], parsing_wrapper(["diamondtopblack"], lang: :asciimath)],
          mathml: ["&#x2b18;"],
          latex: [["diamondtopblack", "&#x2b18;"]],
          omml: ["&#x2b18;"],
          html: ["&#x2b18;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\diamondtopblack"
        end

        def to_asciimath(**)
          parsing_wrapper("diamondtopblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b18;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b18;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b18;"
        end

        def to_html(**)
          "&#x2b18;"
        end
      end
    end
  end
end
