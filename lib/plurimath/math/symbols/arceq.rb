module Plurimath
  module Math
    module Symbols
      class Arceq < Symbol
        INPUT = {
          unicodemath: [["&#x2258;"], parsing_wrapper(["arceq"], lang: :unicode)],
          asciimath: [["&#x2258;"], parsing_wrapper(["arceq"], lang: :asciimath)],
          mathml: ["&#x2258;"],
          latex: [["arceq", "&#x2258;"]],
          omml: ["&#x2258;"],
          html: ["&#x2258;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\arceq"
        end

        def to_asciimath(**)
          parsing_wrapper("arceq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2258;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2258;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2258;"
        end

        def to_html(**)
          "&#x2258;"
        end
      end
    end
  end
end
