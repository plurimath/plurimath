module Plurimath
  module Math
    module Symbols
      class Gtrless < Symbol
        INPUT = {
          unicodemath: [["gtrless", "&#x2277;"], parsing_wrapper(["GreaterLess"], lang: :unicode)],
          asciimath: [["&#x2277;"], parsing_wrapper(["gtrless", "GreaterLess"], lang: :asciimath)],
          mathml: ["&#x2277;"],
          latex: [["GreaterLess", "gtrless", "&#x2277;"]],
          omml: ["&#x2277;"],
          html: ["&#x2277;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\GreaterLess"
        end

        def to_asciimath(**)
          parsing_wrapper("gtrless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2277;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2277;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2277;"
        end

        def to_html(**)
          "&#x2277;"
        end
      end
    end
  end
end
