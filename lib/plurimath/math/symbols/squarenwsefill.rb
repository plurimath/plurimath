module Plurimath
  module Math
    module Symbols
      class Squarenwsefill < Symbol
        INPUT = {
          unicodemath: [["&#x25a7;"], parsing_wrapper(["squarenwsefill"], lang: :unicode)],
          asciimath: [["&#x25a7;"], parsing_wrapper(["squarenwsefill"], lang: :asciimath)],
          mathml: ["&#x25a7;"],
          latex: [["squarenwsefill", "&#x25a7;"]],
          omml: ["&#x25a7;"],
          html: ["&#x25a7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarenwsefill"
        end

        def to_asciimath(**)
          parsing_wrapper("squarenwsefill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a7;"
        end

        def to_html(**)
          "&#x25a7;"
        end
      end
    end
  end
end
