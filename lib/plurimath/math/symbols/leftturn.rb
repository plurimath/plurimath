module Plurimath
  module Math
    module Symbols
      class Leftturn < Symbol
        INPUT = {
          unicodemath: [["circlearrowleft", "&#x21ba;"], parsing_wrapper(["acwopencirclearrow", "leftturn"], lang: :unicode)],
          asciimath: [["&#x21ba;"], parsing_wrapper(["circlearrowleft", "acwopencirclearrow", "leftturn"], lang: :asciimath)],
          mathml: ["&#x21ba;"],
          latex: [["acwopencirclearrow", "circlearrowleft", "leftturn", "&#x21ba;"]],
          omml: ["&#x21ba;"],
          html: ["&#x21ba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acwopencirclearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftturn", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21ba;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21ba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21ba;"
        end

        def to_html(**)
          "&#x21ba;"
        end
      end
    end
  end
end
