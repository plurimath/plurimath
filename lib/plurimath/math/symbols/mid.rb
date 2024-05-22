module Plurimath
  module Math
    module Symbols
      class Mid < Symbol
        INPUT = {
          unicodemath: [["&#x2223;"], parsing_wrapper(["mid"])],
          asciimath: [["&#x2223;"], parsing_wrapper(["mid"])],
          mathml: ["&#x2223;"],
          latex: [["mid", "&#x2223;"]],
          omml: ["&#x2223;"],
          html: ["&#x2223;"],
        }.freeze

        # output methods
        def to_latex
          "\\mid"
        end

        def to_asciimath
          parsing_wrapper("mid")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2223;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x2223;"
        end

        def to_omml_without_math_tag(_)
          "&#x2223;"
        end

        def to_html
          "&#x2223;"
        end
      end
    end
  end
end
