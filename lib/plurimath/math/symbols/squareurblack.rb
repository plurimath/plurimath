module Plurimath
  module Math
    module Symbols
      class Squareurblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b14;"], parsing_wrapper(["squareurblack"], lang: :unicode)],
          asciimath: [["&#x2b14;"], parsing_wrapper(["squareurblack"], lang: :asciimath)],
          mathml: ["&#x2b14;"],
          latex: [["squareurblack", "&#x2b14;"]],
          omml: ["&#x2b14;"],
          html: ["&#x2b14;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squareurblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squareurblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b14;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b14;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b14;"
        end

        def to_html(**)
          "&#x2b14;"
        end
      end
    end
  end
end
