module Plurimath
  module Math
    module Symbols
      class Propertyline < Symbol
        INPUT = {
          unicodemath: [["&#x214a;"], parsing_wrapper(["PropertyLine"], lang: :unicode)],
          asciimath: [["&#x214a;"], parsing_wrapper(["PropertyLine"], lang: :asciimath)],
          mathml: ["&#x214a;"],
          latex: [["PropertyLine", "&#x214a;"]],
          omml: ["&#x214a;"],
          html: ["&#x214a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\PropertyLine"
        end

        def to_asciimath(**)
          parsing_wrapper("PropertyLine", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x214a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x214a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x214a;"
        end

        def to_html(**)
          "&#x214a;"
        end
      end
    end
  end
end
