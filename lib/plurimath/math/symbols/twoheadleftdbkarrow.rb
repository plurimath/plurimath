module Plurimath
  module Math
    module Symbols
      class Twoheadleftdbkarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b37;"], parsing_wrapper(["twoheadleftdbkarrow"], lang: :unicode)],
          asciimath: [["&#x2b37;"], parsing_wrapper(["twoheadleftdbkarrow"], lang: :asciimath)],
          mathml: ["&#x2b37;"],
          latex: [["twoheadleftdbkarrow", "&#x2b37;"]],
          omml: ["&#x2b37;"],
          html: ["&#x2b37;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheadleftdbkarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheadleftdbkarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b37;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b37;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b37;"
        end

        def to_html(**)
          "&#x2b37;"
        end
      end
    end
  end
end
