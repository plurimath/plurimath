module Plurimath
  module Math
    module Symbols
      class Rdsh < Symbol
        INPUT = {
          unicodemath: [["rdsh", "&#x21b3;"], parsing_wrapper(["drsh", "Rdsh"], lang: :unicode)],
          asciimath: [["&#x21b3;"], parsing_wrapper(["rdsh", "drsh", "Rdsh"], lang: :asciimath)],
          mathml: ["&#x21b3;"],
          latex: [["drsh", "Rdsh", "&#x21b3;"], parsing_wrapper(["rdsh"], lang: :latex)],
          omml: ["&#x21b3;"],
          html: ["&#x21b3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\drsh"
        end

        def to_asciimath(**)
          parsing_wrapper("rdsh", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b3;"
        end

        def to_html(**)
          "&#x21b3;"
        end
      end
    end
  end
end
