module Plurimath
  module Math
    module Symbols
      class Circletophalfblack < Symbol
        INPUT = {
          unicodemath: [["&#x25d3;"], parsing_wrapper(["circletophalfblack"], lang: :unicode)],
          asciimath: [["&#x25d3;"], parsing_wrapper(["circletophalfblack"], lang: :asciimath)],
          mathml: ["&#x25d3;"],
          latex: [["circletophalfblack", "&#x25d3;"]],
          omml: ["&#x25d3;"],
          html: ["&#x25d3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circletophalfblack"
        end

        def to_asciimath(**)
          parsing_wrapper("circletophalfblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d3;"
        end

        def to_html(**)
          "&#x25d3;"
        end
      end
    end
  end
end
