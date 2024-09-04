module Plurimath
  module Math
    module Symbols
      class Comp < Symbol
        INPUT = {
          unicodemath: [["&#x2a3e;"], parsing_wrapper(["fcmp", "comp"], lang: :unicode)],
          asciimath: [["&#x2a3e;"], parsing_wrapper(["fcmp", "comp"], lang: :asciimath)],
          mathml: ["&#x2a3e;"],
          latex: [["fcmp", "comp", "&#x2a3e;"]],
          omml: ["&#x2a3e;"],
          html: ["&#x2a3e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fcmp"
        end

        def to_asciimath(**)
          parsing_wrapper("comp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3e;"
        end

        def to_html(**)
          "&#x2a3e;"
        end
      end
    end
  end
end
