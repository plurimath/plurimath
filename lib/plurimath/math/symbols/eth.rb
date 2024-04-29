module Plurimath
  module Math
    module Symbols
      class Eth < Symbol
        INPUT = {
          unicodemath: [["&#xf0;"], parsing_wrapper(["matheth", "eth"])],
          asciimath: [["&#xf0;"], parsing_wrapper(["matheth", "eth"])],
          mathml: ["&#xf0;"],
          latex: [["matheth", "eth", "&#xf0;"]],
          omml: ["&#xf0;"],
          html: ["&#xf0;"],
        }.freeze

        # output methods
        def to_latex
          "\\matheth"
        end

        def to_asciimath
          parsing_wrapper("eth")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#xf0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#xf0;"
        end

        def to_omml_without_math_tag(_)
          "&#xf0;"
        end

        def to_html
          "&#xf0;"
        end
      end
    end
  end
end
