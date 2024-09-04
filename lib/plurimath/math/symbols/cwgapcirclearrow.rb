module Plurimath
  module Math
    module Symbols
      class Cwgapcirclearrow < Symbol
        INPUT = {
          unicodemath: [["&#x27f3;"], parsing_wrapper(["cwgapcirclearrow"], lang: :unicode)],
          asciimath: [["&#x27f3;"], parsing_wrapper(["cwgapcirclearrow"], lang: :asciimath)],
          mathml: ["&#x27f3;"],
          latex: [["cwgapcirclearrow", "&#x27f3;"]],
          omml: ["&#x27f3;"],
          html: ["&#x27f3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cwgapcirclearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("cwgapcirclearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27f3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27f3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27f3;"
        end

        def to_html(**)
          "&#x27f3;"
        end
      end
    end
  end
end
