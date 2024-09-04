module Plurimath
  module Math
    module Symbols
      class Hrectangleblack < Symbol
        INPUT = {
          unicodemath: [["&#x25ac;"], parsing_wrapper(["hrectangleblack"], lang: :unicode)],
          asciimath: [["&#x25ac;"], parsing_wrapper(["hrectangleblack"], lang: :asciimath)],
          mathml: ["&#x25ac;"],
          latex: [["hrectangleblack", "&#x25ac;"]],
          omml: ["&#x25ac;"],
          html: ["&#x25ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hrectangleblack"
        end

        def to_asciimath(**)
          parsing_wrapper("hrectangleblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ac;"
        end

        def to_html(**)
          "&#x25ac;"
        end
      end
    end
  end
end
