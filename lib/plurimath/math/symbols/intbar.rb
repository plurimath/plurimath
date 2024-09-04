module Plurimath
  module Math
    module Symbols
      class Intbar < Symbol
        INPUT = {
          unicodemath: [["&#x2a0e;"], parsing_wrapper(["intBar"], lang: :unicode)],
          asciimath: [["&#x2a0e;"], parsing_wrapper(["intBar"], lang: :asciimath)],
          mathml: ["&#x2a0e;"],
          latex: [["intBar", "&#x2a0e;"]],
          omml: ["&#x2a0e;"],
          html: ["&#x2a0e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intBar"
        end

        def to_asciimath(**)
          parsing_wrapper("intBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a0e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a0e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a0e;"
        end

        def to_html(**)
          "&#x2a0e;"
        end
      end
    end
  end
end
