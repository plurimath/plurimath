module Plurimath
  module Math
    module Symbols
      class Koppa < Symbol
        INPUT = {
          unicodemath: [["&#x3d9;"], parsing_wrapper(["upoldkoppa", "qoppa", "koppa"])],
          asciimath: [["&#x3d9;"], parsing_wrapper(["upoldkoppa", "qoppa", "koppa"])],
          mathml: ["&#x3d9;"],
          latex: [["upoldkoppa", "qoppa", "koppa", "&#x3d9;"]],
          omml: ["&#x3d9;"],
          html: ["&#x3d9;"],
        }.freeze

        # output methods
        def to_latex
          "\\koppa"
        end

        def to_asciimath
          parsing_wrapper("koppa")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3d9;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x3d9;"
        end

        def to_omml_without_math_tag(_)
          "&#x3d9;"
        end

        def to_html
          "&#x3d9;"
        end
      end
    end
  end
end
