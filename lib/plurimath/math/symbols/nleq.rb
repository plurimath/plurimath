module Plurimath
  module Math
    module Symbols
      class Nleq < Symbol
        INPUT = {
          unicodemath: [["nleq", "&#x2270;"], parsing_wrapper(["nleqslant"], lang: :unicode)],
          asciimath: [["&#x2270;"], parsing_wrapper(["nleq", "nleqslant"], lang: :asciimath)],
          mathml: ["&#x2270;"],
          latex: [["nleqslant", "nleq", "&#x2270;"]],
          omml: ["&#x2270;"],
          html: ["&#x2270;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nleqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("nleq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2270;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2270;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2270;"
        end

        def to_html(**)
          "&#x2270;"
        end
      end
    end
  end
end
