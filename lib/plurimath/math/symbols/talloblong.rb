module Plurimath
  module Math
    module Symbols
      class Talloblong < Symbol
        INPUT = {
          unicodemath: [["&#x2afe;"], parsing_wrapper(["talloblong"])],
          asciimath: [["&#x2afe;"], parsing_wrapper(["talloblong"])],
          mathml: ["&#x2afe;"],
          latex: [["talloblong", "&#x2afe;"]],
          omml: ["&#x2afe;"],
          html: ["&#x2afe;"],
        }.freeze

        # output methods
        def to_latex
          "\\talloblong"
        end

        def to_asciimath
          parsing_wrapper("talloblong")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2afe;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2afe;"
        end

        def to_omml_without_math_tag(_)
          "&#x2afe;"
        end

        def to_html
          "&#x2afe;"
        end
      end
    end
  end
end
