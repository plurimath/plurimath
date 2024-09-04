module Plurimath
  module Math
    module Symbols
      class Rightpentagonblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b53;"], parsing_wrapper(["rightpentagonblack"], lang: :unicode)],
          asciimath: [["&#x2b53;"], parsing_wrapper(["rightpentagonblack"], lang: :asciimath)],
          mathml: ["&#x2b53;"],
          latex: [["rightpentagonblack", "&#x2b53;"]],
          omml: ["&#x2b53;"],
          html: ["&#x2b53;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightpentagonblack"
        end

        def to_asciimath(**)
          parsing_wrapper("rightpentagonblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b53;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b53;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b53;"
        end

        def to_html(**)
          "&#x2b53;"
        end
      end
    end
  end
end
