module Plurimath
  module Math
    module Symbols
      class Ntriangleright < Symbol
        INPUT = {
          unicodemath: [["ntriangleright", "&#x22eb;"], parsing_wrapper(["NotRightTriangle"])],
          asciimath: [["&#x22eb;"], parsing_wrapper(["ntriangleright", "NotRightTriangle"])],
          mathml: ["&#x22eb;"],
          latex: [["NotRightTriangle", "ntriangleright", "&#x22eb;"]],
          omml: ["&#x22eb;"],
          html: ["&#x22eb;"],
        }.freeze

        # output methods
        def to_latex
          "\\NotRightTriangle"
        end

        def to_asciimath
          parsing_wrapper("ntriangleright")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22eb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22eb;"
        end

        def to_omml_without_math_tag(_)
          "&#x22eb;"
        end

        def to_html
          "&#x22eb;"
        end
      end
    end
  end
end
