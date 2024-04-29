module Plurimath
  module Math
    module Symbols
      class Lvec < Symbol
        INPUT = {
          unicodemath: [["&#x20d6;"], parsing_wrapper(["overleftarrow", "LVec"])],
          asciimath: [["&#x20d6;"], parsing_wrapper(["overleftarrow", "LVec"])],
          mathml: ["&#x20d6;"],
          latex: [["overleftarrow", "LVec", "&#x20d6;"]],
          omml: ["&#x20d6;"],
          html: ["&#x20d6;"],
        }.freeze

        # output methods
        def to_latex
          "\\overleftarrow"
        end

        def to_asciimath
          parsing_wrapper("LVec")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x20d6;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x20d6;"
        end

        def to_omml_without_math_tag(_)
          "&#x20d6;"
        end

        def to_html
          "&#x20d6;"
        end
      end
    end
  end
end
