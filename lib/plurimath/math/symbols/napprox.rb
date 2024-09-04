module Plurimath
  module Math
    module Symbols
      class Napprox < Symbol
        INPUT = {
          unicodemath: [["napprox", "&#x2249;"]],
          asciimath: [["&#x2249;"], parsing_wrapper(["napprox"], lang: :asciimath)],
          mathml: ["&#x2249;"],
          latex: [["napprox", "&#x2249;"]],
          omml: ["&#x2249;"],
          html: ["&#x2249;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\napprox"
        end

        def to_asciimath(**)
          parsing_wrapper("napprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2249;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2249;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2249;"
        end

        def to_html(**)
          "&#x2249;"
        end
      end
    end
  end
end
