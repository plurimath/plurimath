module Plurimath
  module Math
    module Symbols
      class Disjquant < Symbol
        INPUT = {
          unicodemath: [["&#x2a08;"], parsing_wrapper(["disjquant"], lang: :unicode)],
          asciimath: [["&#x2a08;"], parsing_wrapper(["disjquant"], lang: :asciimath)],
          mathml: ["&#x2a08;"],
          latex: [["disjquant", "&#x2a08;"]],
          omml: ["&#x2a08;"],
          html: ["&#x2a08;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\disjquant"
        end

        def to_asciimath(**)
          parsing_wrapper("disjquant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a08;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a08;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a08;"
        end

        def to_html(**)
          "&#x2a08;"
        end
      end
    end
  end
end
