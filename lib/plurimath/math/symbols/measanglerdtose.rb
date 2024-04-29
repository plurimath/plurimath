module Plurimath
  module Math
    module Symbols
      class Measanglerdtose < Symbol
        INPUT = {
          unicodemath: [["&#x29aa;"], parsing_wrapper(["measanglerdtose"])],
          asciimath: [["&#x29aa;"], parsing_wrapper(["measanglerdtose"])],
          mathml: ["&#x29aa;"],
          latex: [["measanglerdtose", "&#x29aa;"]],
          omml: ["&#x29aa;"],
          html: ["&#x29aa;"],
        }.freeze

        # output methods
        def to_latex
          "\\measanglerdtose"
        end

        def to_asciimath
          parsing_wrapper("measanglerdtose")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29aa;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29aa;"
        end

        def to_omml_without_math_tag(_)
          "&#x29aa;"
        end

        def to_html
          "&#x29aa;"
        end
      end
    end
  end
end
