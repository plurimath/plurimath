module Plurimath
  module Math
    module Symbols
      class Because < Symbol
        INPUT = {
          unicodemath: [["because", "&#x2235;"], parsing_wrapper([":'"], lang: :unicode)],
          asciimath: [["because", ":'", "&#x2235;"]],
          mathml: ["&#x2235;"],
          latex: [["because", "&#x2235;"], parsing_wrapper([":'"], lang: :latex)],
          omml: ["&#x2235;"],
          html: ["&#x2235;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\because"
        end

        def to_asciimath(**)
          "because"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2235;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2235;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2235;"
        end

        def to_html(**)
          "&#x2235;"
        end
      end
    end
  end
end
