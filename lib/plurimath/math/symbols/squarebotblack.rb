module Plurimath
  module Math
    module Symbols
      class Squarebotblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b13;"], parsing_wrapper(["squarebotblack"], lang: :unicode)],
          asciimath: [["&#x2b13;"], parsing_wrapper(["squarebotblack"], lang: :asciimath)],
          mathml: ["&#x2b13;"],
          latex: [["squarebotblack", "&#x2b13;"]],
          omml: ["&#x2b13;"],
          html: ["&#x2b13;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarebotblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squarebotblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b13;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b13;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b13;"
        end

        def to_html(**)
          "&#x2b13;"
        end
      end
    end
  end
end
