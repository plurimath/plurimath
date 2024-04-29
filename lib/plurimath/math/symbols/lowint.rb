module Plurimath
  module Math
    module Symbols
      class Lowint < Symbol
        INPUT = {
          unicodemath: [["&#x2a1c;"], parsing_wrapper(["lowint"])],
          asciimath: [["&#x2a1c;"], parsing_wrapper(["lowint"])],
          mathml: ["&#x2a1c;"],
          latex: [["lowint", "&#x2a1c;"]],
          omml: ["&#x2a1c;"],
          html: ["&#x2a1c;"],
        }.freeze

        # output methods
        def to_latex
          "\\lowint"
        end

        def to_asciimath
          parsing_wrapper("lowint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a1c;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a1c;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a1c;"
        end

        def to_html
          "&#x2a1c;"
        end
      end
    end
  end
end
