module Plurimath
  module Math
    module Symbols
      class Rsh < Symbol
        INPUT = {
          unicodemath: [["&#x21b1;"], parsing_wrapper(["Rsh"], lang: :unicode)],
          asciimath: [["&#x21b1;"], parsing_wrapper(["Rsh"], lang: :asciimath)],
          mathml: ["&#x21b1;"],
          latex: [["Rsh", "&#x21b1;"]],
          omml: ["&#x21b1;"],
          html: ["&#x21b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Rsh"
        end

        def to_asciimath(**)
          parsing_wrapper("Rsh", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b1;"
        end

        def to_html(**)
          "&#x21b1;"
        end
      end
    end
  end
end
