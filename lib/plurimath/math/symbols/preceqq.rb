module Plurimath
  module Math
    module Symbols
      class Preceqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab3;"], parsing_wrapper(["preceqq"])],
          asciimath: [["&#x2ab3;"], parsing_wrapper(["preceqq"])],
          mathml: ["&#x2ab3;"],
          latex: [["preceqq", "&#x2ab3;"]],
          omml: ["&#x2ab3;"],
          html: ["&#x2ab3;"],
        }.freeze

        # output methods
        def to_latex
          "\\preceqq"
        end

        def to_asciimath
          parsing_wrapper("preceqq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ab3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ab3;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ab3;"
        end

        def to_html
          "&#x2ab3;"
        end
      end
    end
  end
end
