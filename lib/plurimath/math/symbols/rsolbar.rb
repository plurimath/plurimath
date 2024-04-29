module Plurimath
  module Math
    module Symbols
      class Rsolbar < Symbol
        INPUT = {
          unicodemath: [["&#x29f7;"], parsing_wrapper(["rsolbar"])],
          asciimath: [["&#x29f7;"], parsing_wrapper(["rsolbar"])],
          mathml: ["&#x29f7;"],
          latex: [["rsolbar", "&#x29f7;"]],
          omml: ["&#x29f7;"],
          html: ["&#x29f7;"],
        }.freeze

        # output methods
        def to_latex
          "\\rsolbar"
        end

        def to_asciimath
          parsing_wrapper("rsolbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29f7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29f7;"
        end

        def to_omml_without_math_tag(_)
          "&#x29f7;"
        end

        def to_html
          "&#x29f7;"
        end
      end
    end
  end
end
