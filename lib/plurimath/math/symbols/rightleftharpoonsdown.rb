module Plurimath
  module Math
    module Symbols
      class Rightleftharpoonsdown < Symbol
        INPUT = {
          unicodemath: [["&#x2969;"], parsing_wrapper(["rightleftharpoonsdown"], lang: :unicode)],
          asciimath: [["&#x2969;"], parsing_wrapper(["rightleftharpoonsdown"], lang: :asciimath)],
          mathml: ["&#x2969;"],
          latex: [["rightleftharpoonsdown", "&#x2969;"]],
          omml: ["&#x2969;"],
          html: ["&#x2969;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightleftharpoonsdown"
        end

        def to_asciimath(**)
          parsing_wrapper("rightleftharpoonsdown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2969;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2969;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2969;"
        end

        def to_html(**)
          "&#x2969;"
        end
      end
    end
  end
end
