module Plurimath
  module Math
    module Symbols
      class Lescc < Symbol
        INPUT = {
          unicodemath: [["&#x2aa8;"], parsing_wrapper(["lescc"], lang: :unicode)],
          asciimath: [["&#x2aa8;"], parsing_wrapper(["lescc"], lang: :asciimath)],
          mathml: ["&#x2aa8;"],
          latex: [["lescc", "&#x2aa8;"]],
          omml: ["&#x2aa8;"],
          html: ["&#x2aa8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lescc"
        end

        def to_asciimath(**)
          parsing_wrapper("lescc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa8;"
        end

        def to_html(**)
          "&#x2aa8;"
        end
      end
    end
  end
end
