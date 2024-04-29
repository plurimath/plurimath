module Plurimath
  module Math
    module Symbols
      class Medsp < Symbol
        INPUT = {
          unicodemath: [["medsp", "&#x205f;"], parsing_wrapper(["medspace"])],
          asciimath: [["&#x205f;"], parsing_wrapper(["medsp", "medspace"])],
          mathml: ["&#x205f;"],
          latex: [["medspace", "&#x205f;"], parsing_wrapper(["medsp"])],
          omml: ["&#x205f;"],
          html: ["&#x205f;"],
        }.freeze

        # output methods
        def to_latex
          "\\medspace"
        end

        def to_asciimath
          parsing_wrapper("medsp")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x205f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x205f;"
        end

        def to_omml_without_math_tag(_)
          "&#x205f;"
        end

        def to_html
          "&#x205f;"
        end
      end
    end
  end
end
