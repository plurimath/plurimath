module Plurimath
  module Math
    module Symbols
      class Medwhitestar < Symbol
        INPUT = {
          unicodemath: [["&#x2b50;"], parsing_wrapper(["medwhitestar"])],
          asciimath: [["&#x2b50;"], parsing_wrapper(["medwhitestar"])],
          mathml: ["&#x2b50;"],
          latex: [["medwhitestar", "&#x2b50;"]],
          omml: ["&#x2b50;"],
          html: ["&#x2b50;"],
        }.freeze

        # output methods
        def to_latex
          "\\medwhitestar"
        end

        def to_asciimath
          parsing_wrapper("medwhitestar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b50;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b50;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b50;"
        end

        def to_html
          "&#x2b50;"
        end
      end
    end
  end
end
