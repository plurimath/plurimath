module Plurimath
  module Math
    module Symbols
      class Vartriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25b5;"], parsing_wrapper(["smalltriangleup", "vartriangle"], lang: :unicode)],
          asciimath: [["&#x25b5;"], parsing_wrapper(["smalltriangleup", "vartriangle"], lang: :asciimath)],
          mathml: ["&#x25b5;"],
          latex: [["smalltriangleup", "vartriangle", "&#x25b5;"]],
          omml: ["&#x25b5;"],
          html: ["&#x25b5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smalltriangleup"
        end

        def to_asciimath(**)
          parsing_wrapper("vartriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b5;"
        end

        def to_html(**)
          "&#x25b5;"
        end
      end
    end
  end
end
