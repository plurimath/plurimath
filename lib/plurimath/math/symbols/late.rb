module Plurimath
  module Math
    module Symbols
      class Late < Symbol
        INPUT = {
          unicodemath: [["&#x2aad;"], parsing_wrapper(["late"], lang: :unicode)],
          asciimath: [["&#x2aad;"], parsing_wrapper(["late"], lang: :asciimath)],
          mathml: ["&#x2aad;"],
          latex: [["late", "&#x2aad;"]],
          omml: ["&#x2aad;"],
          html: ["&#x2aad;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\late"
        end

        def to_asciimath(**)
          parsing_wrapper("late", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aad;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aad;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aad;"
        end

        def to_html(**)
          "&#x2aad;"
        end
      end
    end
  end
end
