module Plurimath
  module Math
    module Symbols
      class Forall < Symbol
        INPUT = {
          unicodemath: [["forall", "&#x2200;"], parsing_wrapper(["AA"], lang: :unicode)],
          asciimath: [["forall", "AA", "&#x2200;"]],
          mathml: ["&#x2200;"],
          latex: [["forall", "&#x2200;"], parsing_wrapper(["AA"], lang: :latex)],
          omml: ["&#x2200;"],
          html: ["&#x2200;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\forall"
        end

        def to_asciimath(**)
          parsing_wrapper("forall", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2200;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2200;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2200;"
        end

        def to_html(**)
          "&#x2200;"
        end
      end
    end
  end
end
