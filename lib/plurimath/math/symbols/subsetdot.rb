module Plurimath
  module Math
    module Symbols
      class Subsetdot < Symbol
        INPUT = {
          unicodemath: [["&#x2abd;"], parsing_wrapper(["subsetdot"], lang: :unicode)],
          asciimath: [["&#x2abd;"], parsing_wrapper(["subsetdot"], lang: :asciimath)],
          mathml: ["&#x2abd;"],
          latex: [["subsetdot", "&#x2abd;"]],
          omml: ["&#x2abd;"],
          html: ["&#x2abd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsetdot"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2abd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2abd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2abd;"
        end

        def to_html(**)
          "&#x2abd;"
        end
      end
    end
  end
end
