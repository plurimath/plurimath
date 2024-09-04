module Plurimath
  module Math
    module Symbols
      class Tminus < Symbol
        INPUT = {
          unicodemath: [["&#x29ff;"], parsing_wrapper(["tminus"], lang: :unicode)],
          asciimath: [["&#x29ff;"], parsing_wrapper(["tminus"], lang: :asciimath)],
          mathml: ["&#x29ff;"],
          latex: [["tminus", "&#x29ff;"]],
          omml: ["&#x29ff;"],
          html: ["&#x29ff;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tminus"
        end

        def to_asciimath(**)
          parsing_wrapper("tminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ff;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ff;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ff;"
        end

        def to_html(**)
          "&#x29ff;"
        end
      end
    end
  end
end
