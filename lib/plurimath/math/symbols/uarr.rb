module Plurimath
  module Math
    module Symbols
      class Uarr < Symbol
        INPUT = {
          unicodemath: [["uparrow", "&#x2191;"], parsing_wrapper(["uarr"], lang: :unicode)],
          asciimath: [["uparrow", "uarr", "&#x2191;"]],
          mathml: ["&#x2191;"],
          latex: [["uparrow", "&#x2191;"], parsing_wrapper(["uarr"], lang: :latex)],
          omml: ["&#x2191;"],
          html: ["&#x2191;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uparrow"
        end

        def to_asciimath(**)
          "uparrow"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2191;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2191;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2191;"
        end

        def to_html(**)
          "&#x2191;"
        end
      end
    end
  end
end
