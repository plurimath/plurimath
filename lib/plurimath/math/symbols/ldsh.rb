module Plurimath
  module Math
    module Symbols
      class Ldsh < Symbol
        INPUT = {
          unicodemath: [["ldsh", "&#x21b2;"], parsing_wrapper(["dlsh", "Ldsh"], lang: :unicode)],
          asciimath: [["&#x21b2;"], parsing_wrapper(["ldsh", "dlsh", "Ldsh"], lang: :asciimath)],
          mathml: ["&#x21b2;"],
          latex: [["dlsh", "Ldsh", "&#x21b2;"], parsing_wrapper(["ldsh"], lang: :latex)],
          omml: ["&#x21b2;"],
          html: ["&#x21b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dlsh"
        end

        def to_asciimath(**)
          parsing_wrapper("ldsh", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b2;"
        end

        def to_html(**)
          "&#x21b2;"
        end
      end
    end
  end
end
