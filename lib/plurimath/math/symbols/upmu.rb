module Plurimath
  module Math
    module Symbols
      class Upmu < Symbol
        INPUT = {
          unicodemath: [["&#x39c;"], parsing_wrapper(["upMu"], lang: :unicode)],
          asciimath: [["&#x39c;"], parsing_wrapper(["upMu"], lang: :asciimath)],
          mathml: ["&#x39c;"],
          latex: [["upMu", "&#x39c;"]],
          omml: ["&#x39c;"],
          html: ["&#x39c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upMu"
        end

        def to_asciimath(**)
          parsing_wrapper("upMu", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x39c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x39c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x39c;"
        end

        def to_html(**)
          "&#x39c;"
        end
      end
    end
  end
end
