module Plurimath
  module Math
    module Symbols
      class Vrectangleblack < Symbol
        INPUT = {
          unicodemath: [["&#x25ae;"], parsing_wrapper(["vrectangleblack"], lang: :unicode)],
          asciimath: [["&#x25ae;"], parsing_wrapper(["vrectangleblack"], lang: :asciimath)],
          mathml: ["&#x25ae;"],
          latex: [["vrectangleblack", "&#x25ae;"]],
          omml: ["&#x25ae;"],
          html: ["&#x25ae;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vrectangleblack"
        end

        def to_asciimath(**)
          parsing_wrapper("vrectangleblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ae;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ae;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ae;"
        end

        def to_html(**)
          "&#x25ae;"
        end
      end
    end
  end
end
