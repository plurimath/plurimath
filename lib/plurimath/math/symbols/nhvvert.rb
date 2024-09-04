module Plurimath
  module Math
    module Symbols
      class Nhvvert < Symbol
        INPUT = {
          unicodemath: [["&#x2af5;"], parsing_wrapper(["nhVvert"], lang: :unicode)],
          asciimath: [["&#x2af5;"], parsing_wrapper(["nhVvert"], lang: :asciimath)],
          mathml: ["&#x2af5;"],
          latex: [["nhVvert", "&#x2af5;"]],
          omml: ["&#x2af5;"],
          html: ["&#x2af5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nhVvert"
        end

        def to_asciimath(**)
          parsing_wrapper("nhVvert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af5;"
        end

        def to_html(**)
          "&#x2af5;"
        end
      end
    end
  end
end
