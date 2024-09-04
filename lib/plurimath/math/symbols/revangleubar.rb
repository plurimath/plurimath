module Plurimath
  module Math
    module Symbols
      class Revangleubar < Symbol
        INPUT = {
          unicodemath: [["&#x29a5;"], parsing_wrapper(["revangleubar"], lang: :unicode)],
          asciimath: [["&#x29a5;"], parsing_wrapper(["revangleubar"], lang: :asciimath)],
          mathml: ["&#x29a5;"],
          latex: [["revangleubar", "&#x29a5;"]],
          omml: ["&#x29a5;"],
          html: ["&#x29a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\revangleubar"
        end

        def to_asciimath(**)
          parsing_wrapper("revangleubar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a5;"
        end

        def to_html(**)
          "&#x29a5;"
        end
      end
    end
  end
end
