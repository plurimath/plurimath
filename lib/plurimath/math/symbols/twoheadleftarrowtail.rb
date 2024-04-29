module Plurimath
  module Math
    module Symbols
      class Twoheadleftarrowtail < Symbol
        INPUT = {
          unicodemath: [["&#x2b3b;"], parsing_wrapper(["twoheadleftarrowtail"])],
          asciimath: [["&#x2b3b;"], parsing_wrapper(["twoheadleftarrowtail"])],
          mathml: ["&#x2b3b;"],
          latex: [["twoheadleftarrowtail", "&#x2b3b;"]],
          omml: ["&#x2b3b;"],
          html: ["&#x2b3b;"],
        }.freeze

        # output methods
        def to_latex
          "\\twoheadleftarrowtail"
        end

        def to_asciimath
          parsing_wrapper("twoheadleftarrowtail")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b3b;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b3b;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b3b;"
        end

        def to_html
          "&#x2b3b;"
        end
      end
    end
  end
end
