module Plurimath
  module Math
    module Symbols
      class Circlebottomhalfblack < Symbol
        INPUT = {
          unicodemath: [["&#x25d2;"], parsing_wrapper(["circlebottomhalfblack"], lang: :unicode)],
          asciimath: [["&#x25d2;"], parsing_wrapper(["circlebottomhalfblack"], lang: :asciimath)],
          mathml: ["&#x25d2;"],
          latex: [["circlebottomhalfblack", "&#x25d2;"]],
          omml: ["&#x25d2;"],
          html: ["&#x25d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circlebottomhalfblack"
        end

        def to_asciimath(**)
          parsing_wrapper("circlebottomhalfblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d2;"
        end

        def to_html(**)
          "&#x25d2;"
        end
      end
    end
  end
end
