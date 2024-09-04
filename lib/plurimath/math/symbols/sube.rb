module Plurimath
  module Math
    module Symbols
      class Sube < Symbol
        INPUT = {
          unicodemath: [["&#x2286;"], parsing_wrapper(["subseteq", "sube"], lang: :unicode)],
          asciimath: [["subseteq", "sube", "&#x2286;"]],
          mathml: ["&#x2286;"],
          latex: [["subseteq", "&#x2286;"], parsing_wrapper(["sube"], lang: :latex)],
          omml: ["&#x2286;"],
          html: ["&#x2286;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subseteq"
        end

        def to_asciimath(**)
          "subseteq"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2286;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2286;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2286;"
        end

        def to_html(**)
          "&#x2286;"
        end
      end
    end
  end
end
