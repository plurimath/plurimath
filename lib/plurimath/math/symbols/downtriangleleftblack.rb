module Plurimath
  module Math
    module Symbols
      class Downtriangleleftblack < Symbol
        INPUT = {
          unicodemath: [["&#x29e8;"], parsing_wrapper(["downtriangleleftblack"])],
          asciimath: [["&#x29e8;"], parsing_wrapper(["downtriangleleftblack"])],
          mathml: ["&#x29e8;"],
          latex: [["downtriangleleftblack", "&#x29e8;"]],
          omml: ["&#x29e8;"],
          html: ["&#x29e8;"],
        }.freeze

        # output methods
        def to_latex
          "\\downtriangleleftblack"
        end

        def to_asciimath
          parsing_wrapper("downtriangleleftblack")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29e8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29e8;"
        end

        def to_omml_without_math_tag(_)
          "&#x29e8;"
        end

        def to_html
          "&#x29e8;"
        end
      end
    end
  end
end
