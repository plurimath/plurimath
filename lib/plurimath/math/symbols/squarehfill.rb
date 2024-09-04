module Plurimath
  module Math
    module Symbols
      class Squarehfill < Symbol
        INPUT = {
          unicodemath: [["&#x25a4;"], parsing_wrapper(["squarehfill"], lang: :unicode)],
          asciimath: [["&#x25a4;"], parsing_wrapper(["squarehfill"], lang: :asciimath)],
          mathml: ["&#x25a4;"],
          latex: [["squarehfill", "&#x25a4;"]],
          omml: ["&#x25a4;"],
          html: ["&#x25a4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarehfill"
        end

        def to_asciimath(**)
          parsing_wrapper("squarehfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a4;"
        end

        def to_html(**)
          "&#x25a4;"
        end
      end
    end
  end
end
