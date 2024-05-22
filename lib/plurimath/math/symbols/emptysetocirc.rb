module Plurimath
  module Math
    module Symbols
      class Emptysetocirc < Symbol
        INPUT = {
          unicodemath: [["&#x29b2;"], parsing_wrapper(["emptysetocirc"])],
          asciimath: [["&#x29b2;"], parsing_wrapper(["emptysetocirc"])],
          mathml: ["&#x29b2;"],
          latex: [["emptysetocirc", "&#x29b2;"]],
          omml: ["&#x29b2;"],
          html: ["&#x29b2;"],
        }.freeze

        # output methods
        def to_latex
          "\\emptysetocirc"
        end

        def to_asciimath
          parsing_wrapper("emptysetocirc")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29b2;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x29b2;"
        end

        def to_omml_without_math_tag(_)
          "&#x29b2;"
        end

        def to_html
          "&#x29b2;"
        end
      end
    end
  end
end
