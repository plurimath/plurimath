module Plurimath
  module Math
    module Symbols
      class Darr < Symbol
        INPUT = {
          unicodemath: [["downarrow", "&#x2193;"], parsing_wrapper(["darr"], lang: :unicode)],
          asciimath: [["downarrow", "darr", "&#x2193;"]],
          mathml: ["&#x2193;"],
          latex: [["downarrow", "&#x2193;"], parsing_wrapper(["darr"], lang: :latex)],
          omml: ["&#x2193;"],
          html: ["&#x2193;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downarrow"
        end

        def to_asciimath(**)
          "downarrow"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2193;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2193;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2193;"
        end

        def to_html(**)
          "&#x2193;"
        end
      end
    end
  end
end
