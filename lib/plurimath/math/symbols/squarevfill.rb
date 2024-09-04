module Plurimath
  module Math
    module Symbols
      class Squarevfill < Symbol
        INPUT = {
          unicodemath: [["&#x25a5;"], parsing_wrapper(["squarevfill"], lang: :unicode)],
          asciimath: [["&#x25a5;"], parsing_wrapper(["squarevfill"], lang: :asciimath)],
          mathml: ["&#x25a5;"],
          latex: [["squarevfill", "&#x25a5;"]],
          omml: ["&#x25a5;"],
          html: ["&#x25a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarevfill"
        end

        def to_asciimath(**)
          parsing_wrapper("squarevfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a5;"
        end

        def to_html(**)
          "&#x25a5;"
        end
      end
    end
  end
end
