module Plurimath
  module Math
    module Symbols
      class Overbracket < Symbol
        INPUT = {
          unicodemath: [["&#x23b4;"], parsing_wrapper(["overbracket"], lang: :unicode)],
          asciimath: [["&#x23b4;"], parsing_wrapper(["overbracket"], lang: :asciimath)],
          mathml: ["&#x23b4;"],
          latex: [["overbracket", "&#x23b4;"]],
          omml: ["&#x23b4;"],
          html: ["&#x23b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\overbracket"
        end

        def to_asciimath(**)
          parsing_wrapper("overbracket", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b4;"
        end

        def to_html(**)
          "&#x23b4;"
        end
      end
    end
  end
end
