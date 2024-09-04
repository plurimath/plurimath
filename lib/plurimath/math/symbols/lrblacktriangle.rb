module Plurimath
  module Math
    module Symbols
      class Lrblacktriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25e2;"], parsing_wrapper(["lrblacktriangle"], lang: :unicode)],
          asciimath: [["&#x25e2;"], parsing_wrapper(["lrblacktriangle"], lang: :asciimath)],
          mathml: ["&#x25e2;"],
          latex: [["lrblacktriangle", "&#x25e2;"]],
          omml: ["&#x25e2;"],
          html: ["&#x25e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lrblacktriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("lrblacktriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e2;"
        end

        def to_html(**)
          "&#x25e2;"
        end
      end
    end
  end
end
