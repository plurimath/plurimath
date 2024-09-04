module Plurimath
  module Math
    module Symbols
      class Isindot < Symbol
        INPUT = {
          unicodemath: [["&#x22f5;"], parsing_wrapper(["isindot"], lang: :unicode)],
          asciimath: [["&#x22f5;"], parsing_wrapper(["isindot"], lang: :asciimath)],
          mathml: ["&#x22f5;"],
          latex: [["isindot", "&#x22f5;"]],
          omml: ["&#x22f5;"],
          html: ["&#x22f5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\isindot"
        end

        def to_asciimath(**)
          parsing_wrapper("isindot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f5;"
        end

        def to_html(**)
          "&#x22f5;"
        end
      end
    end
  end
end
