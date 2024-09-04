module Plurimath
  module Math
    module Symbols
      class Pentagonblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b1f;"], parsing_wrapper(["pentagonblack"], lang: :unicode)],
          asciimath: [["&#x2b1f;"], parsing_wrapper(["pentagonblack"], lang: :asciimath)],
          mathml: ["&#x2b1f;"],
          latex: [["pentagonblack", "&#x2b1f;"]],
          omml: ["&#x2b1f;"],
          html: ["&#x2b1f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pentagonblack"
        end

        def to_asciimath(**)
          parsing_wrapper("pentagonblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b1f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b1f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b1f;"
        end

        def to_html(**)
          "&#x2b1f;"
        end
      end
    end
  end
end
