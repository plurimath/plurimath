module Plurimath
  module Math
    module Symbols
      class Therefore < Symbol
        INPUT = {
          unicodemath: [["therefore", "&#x2234;"], parsing_wrapper([":.", "wasytherefore"], lang: :unicode)],
          asciimath: [["therefore", ":.", "&#x2234;"], parsing_wrapper(["wasytherefore"], lang: :asciimath)],
          mathml: ["&#x2234;"],
          latex: [["wasytherefore", "therefore", "&#x2234;"], parsing_wrapper([":."], lang: :latex)],
          omml: ["&#x2234;"],
          html: ["&#x2234;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\therefore"
        end

        def to_asciimath(**)
          "therefore"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2234;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2234;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2234;"
        end

        def to_html(**)
          "&#x2234;"
        end
      end
    end
  end
end
