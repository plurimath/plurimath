module Plurimath
  module Math
    module Symbols
      class Eqcirc < Symbol
        INPUT = {
          unicodemath: [["eqcirc", "&#x2256;"]],
          asciimath: [["&#x2256;"], parsing_wrapper(["eqcirc"], lang: :asciimath)],
          mathml: ["&#x2256;"],
          latex: [["eqcirc", "&#x2256;"]],
          omml: ["&#x2256;"],
          html: ["&#x2256;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqcirc"
        end

        def to_asciimath(**)
          parsing_wrapper("eqcirc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2256;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2256;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2256;"
        end

        def to_html(**)
          "&#x2256;"
        end
      end
    end
  end
end
