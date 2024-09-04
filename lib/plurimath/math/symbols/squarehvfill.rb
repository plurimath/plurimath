module Plurimath
  module Math
    module Symbols
      class Squarehvfill < Symbol
        INPUT = {
          unicodemath: [["&#x25a6;"], parsing_wrapper(["squarehvfill"], lang: :unicode)],
          asciimath: [["&#x25a6;"], parsing_wrapper(["squarehvfill"], lang: :asciimath)],
          mathml: ["&#x25a6;"],
          latex: [["squarehvfill", "&#x25a6;"]],
          omml: ["&#x25a6;"],
          html: ["&#x25a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarehvfill"
        end

        def to_asciimath(**)
          parsing_wrapper("squarehvfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a6;"
        end

        def to_html(**)
          "&#x25a6;"
        end
      end
    end
  end
end
