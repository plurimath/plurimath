module Plurimath
  module Math
    module Symbols
      class Downarrows < Symbol
        INPUT = {
          unicodemath: [["downarrows", "&#x21ca;"], parsing_wrapper(["downdownarrows"])],
          asciimath: [["&#x21ca;"], parsing_wrapper(["downarrows", "downdownarrows"])],
          mathml: ["&#x21ca;"],
          latex: [["downdownarrows", "&#x21ca;"], parsing_wrapper(["downarrows"])],
          omml: ["&#x21ca;"],
          html: ["&#x21ca;"],
        }.freeze

        # output methods
        def to_latex
          "\\downdownarrows"
        end

        def to_asciimath
          parsing_wrapper("downarrows")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21ca;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21ca;"
        end

        def to_omml_without_math_tag(_)
          "&#x21ca;"
        end

        def to_html
          "&#x21ca;"
        end
      end
    end
  end
end
