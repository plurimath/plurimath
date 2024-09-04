module Plurimath
  module Math
    module Symbols
      class Acwgapcirclearrow < Symbol
        INPUT = {
          unicodemath: [["&#x27f2;"], parsing_wrapper(["acwgapcirclearrow"], lang: :unicode)],
          asciimath: [["&#x27f2;"], parsing_wrapper(["acwgapcirclearrow"], lang: :asciimath)],
          mathml: ["&#x27f2;"],
          latex: [["acwgapcirclearrow", "&#x27f2;"]],
          omml: ["&#x27f2;"],
          html: ["&#x27f2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acwgapcirclearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("acwgapcirclearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27f2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27f2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27f2;"
        end

        def to_html(**)
          "&#x27f2;"
        end
      end
    end
  end
end
