module Plurimath
  module Math
    module Symbols
      class Preceq < Symbol
        INPUT = {
          unicodemath: [["preceq", "&#x2aaf;"], parsing_wrapper(["-<="], lang: :unicode)],
          asciimath: [["preceq", "-<=", "&#x2aaf;"]],
          mathml: ["&#x2aaf;"],
          latex: [["preceq", "&#x2aaf;"], parsing_wrapper(["-<="], lang: :latex)],
          omml: ["&#x2aaf;"],
          html: ["&#x2aaf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\preceq"
        end

        def to_asciimath(**)
          "preceq"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aaf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aaf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aaf;"
        end

        def to_html(**)
          "&#x2aaf;"
        end
      end
    end
  end
end
