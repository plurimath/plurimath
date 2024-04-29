module Plurimath
  module Math
    module Symbols
      class Sqcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a4f;"], parsing_wrapper(["Sqcup"])],
          asciimath: [["&#x2a4f;"], parsing_wrapper(["Sqcup"])],
          mathml: ["&#x2a4f;"],
          latex: [["Sqcup", "&#x2a4f;"]],
          omml: ["&#x2a4f;"],
          html: ["&#x2a4f;"],
        }.freeze

        # output methods
        def to_latex
          "\\Sqcup"
        end

        def to_asciimath
          parsing_wrapper("Sqcup")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a4f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a4f;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a4f;"
        end

        def to_html
          "&#x2a4f;"
        end
      end
    end
  end
end
