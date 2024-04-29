module Plurimath
  module Math
    module Symbols
      class Forksnot < Symbol
        INPUT = {
          unicodemath: [["&#x2add;"], parsing_wrapper(["forksnot"])],
          asciimath: [["&#x2add;"], parsing_wrapper(["forksnot"])],
          mathml: ["&#x2add;"],
          latex: [["forksnot", "&#x2add;"]],
          omml: ["&#x2add;"],
          html: ["&#x2add;"],
        }.freeze

        # output methods
        def to_latex
          "\\forksnot"
        end

        def to_asciimath
          parsing_wrapper("forksnot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2add;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2add;"
        end

        def to_omml_without_math_tag(_)
          "&#x2add;"
        end

        def to_html
          "&#x2add;"
        end
      end
    end
  end
end
