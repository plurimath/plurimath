module Plurimath
  module Math
    module Symbols
      class Ntriangleright < Symbol
        INPUT = {
          unicodemath: [["ntriangleright", "&#x22eb;"], parsing_wrapper(["NotRightTriangle"], lang: :unicode)],
          asciimath: [["&#x22eb;"], parsing_wrapper(["ntriangleright", "NotRightTriangle"], lang: :asciimath)],
          mathml: ["&#x22eb;"],
          latex: [["NotRightTriangle", "ntriangleright", "&#x22eb;"]],
          omml: ["&#x22eb;"],
          html: ["&#x22eb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\NotRightTriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("ntriangleright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22eb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22eb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22eb;"
        end

        def to_html(**)
          "&#x22eb;"
        end
      end
    end
  end
end
