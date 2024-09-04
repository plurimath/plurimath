module Plurimath
  module Math
    module Symbols
      class Squaretopblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b12;"], parsing_wrapper(["squaretopblack"], lang: :unicode)],
          asciimath: [["&#x2b12;"], parsing_wrapper(["squaretopblack"], lang: :asciimath)],
          mathml: ["&#x2b12;"],
          latex: [["squaretopblack", "&#x2b12;"]],
          omml: ["&#x2b12;"],
          html: ["&#x2b12;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squaretopblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squaretopblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b12;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b12;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b12;"
        end

        def to_html(**)
          "&#x2b12;"
        end
      end
    end
  end
end
