module Plurimath
  module Math
    module Symbols
      class Llcorner < Symbol
        INPUT = {
          unicodemath: [["&#x231e;"], parsing_wrapper(["llcorner"], lang: :unicode)],
          asciimath: [["&#x231e;"], parsing_wrapper(["llcorner"], lang: :asciimath)],
          mathml: ["&#x231e;"],
          latex: [["llcorner", "&#x231e;"]],
          omml: ["&#x231e;"],
          html: ["&#x231e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\llcorner"
        end

        def to_asciimath(**)
          parsing_wrapper("llcorner", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x231e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x231e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x231e;"
        end

        def to_html(**)
          "&#x231e;"
        end
      end
    end
  end
end
