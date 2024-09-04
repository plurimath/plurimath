module Plurimath
  module Math
    module Symbols
      class Squareleftblack < Symbol
        INPUT = {
          unicodemath: [["&#x25e7;"], parsing_wrapper(["squareleftblack"], lang: :unicode)],
          asciimath: [["&#x25e7;"], parsing_wrapper(["squareleftblack"], lang: :asciimath)],
          mathml: ["&#x25e7;"],
          latex: [["squareleftblack", "&#x25e7;"]],
          omml: ["&#x25e7;"],
          html: ["&#x25e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squareleftblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squareleftblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e7;"
        end

        def to_html(**)
          "&#x25e7;"
        end
      end
    end
  end
end
