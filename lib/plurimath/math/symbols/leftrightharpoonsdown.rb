module Plurimath
  module Math
    module Symbols
      class Leftrightharpoonsdown < Symbol
        INPUT = {
          unicodemath: [["&#x2967;"], parsing_wrapper(["leftrightharpoonsdown"], lang: :unicode)],
          asciimath: [["&#x2967;"], parsing_wrapper(["leftrightharpoonsdown"], lang: :asciimath)],
          mathml: ["&#x2967;"],
          latex: [["leftrightharpoonsdown", "&#x2967;"]],
          omml: ["&#x2967;"],
          html: ["&#x2967;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightharpoonsdown"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightharpoonsdown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2967;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2967;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2967;"
        end

        def to_html(**)
          "&#x2967;"
        end
      end
    end
  end
end
