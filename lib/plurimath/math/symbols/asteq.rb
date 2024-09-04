module Plurimath
  module Math
    module Symbols
      class Asteq < Symbol
        INPUT = {
          unicodemath: [["&#x2a6e;"], parsing_wrapper(["asteq"], lang: :unicode)],
          asciimath: [["&#x2a6e;"], parsing_wrapper(["asteq"], lang: :asciimath)],
          mathml: ["&#x2a6e;"],
          latex: [["asteq", "&#x2a6e;"]],
          omml: ["&#x2a6e;"],
          html: ["&#x2a6e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\asteq"
        end

        def to_asciimath(**)
          parsing_wrapper("asteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a6e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a6e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a6e;"
        end

        def to_html(**)
          "&#x2a6e;"
        end
      end
    end
  end
end
