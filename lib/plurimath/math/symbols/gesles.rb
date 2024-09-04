module Plurimath
  module Math
    module Symbols
      class Gesles < Symbol
        INPUT = {
          unicodemath: [["&#x2a94;"], parsing_wrapper(["gesles"], lang: :unicode)],
          asciimath: [["&#x2a94;"], parsing_wrapper(["gesles"], lang: :asciimath)],
          mathml: ["&#x2a94;"],
          latex: [["gesles", "&#x2a94;"]],
          omml: ["&#x2a94;"],
          html: ["&#x2a94;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gesles"
        end

        def to_asciimath(**)
          parsing_wrapper("gesles", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a94;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a94;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a94;"
        end

        def to_html(**)
          "&#x2a94;"
        end
      end
    end
  end
end
