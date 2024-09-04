module Plurimath
  module Math
    module Symbols
      class Mho < Symbol
        INPUT = {
          unicodemath: [["&#x2127;"], parsing_wrapper(["mho", "Mho"], lang: :unicode)],
          asciimath: [["&#x2127;"], parsing_wrapper(["mho", "Mho"], lang: :asciimath)],
          mathml: ["&#x2127;"],
          latex: [["mho", "Mho", "&#x2127;"]],
          omml: ["&#x2127;"],
          html: ["&#x2127;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mho"
        end

        def to_asciimath(**)
          parsing_wrapper("Mho", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2127;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2127;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2127;"
        end

        def to_html(**)
          "&#x2127;"
        end
      end
    end
  end
end
