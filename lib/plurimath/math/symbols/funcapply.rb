module Plurimath
  module Math
    module Symbols
      class Funcapply < Symbol
        INPUT = {
          unicodemath: [["funcapply", "&#x2061;"]],
          asciimath: [["&#x2061;"], parsing_wrapper(["funcapply"], lang: :asciimath)],
          mathml: ["&#x2061;"],
          latex: [["&#x2061;"], parsing_wrapper(["funcapply"], lang: :latex)],
          omml: ["&#x2061;"],
          html: ["&#x2061;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("funcapply", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("funcapply", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2061;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2061;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2061;"
        end

        def to_html(**)
          "&#x2061;"
        end
      end
    end
  end
end
