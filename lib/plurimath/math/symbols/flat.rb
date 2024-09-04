module Plurimath
  module Math
    module Symbols
      class Flat < Symbol
        INPUT = {
          unicodemath: [["&#x266d;"], parsing_wrapper(["flat"], lang: :unicode)],
          asciimath: [["&#x266d;"], parsing_wrapper(["flat"], lang: :asciimath)],
          mathml: ["&#x266d;"],
          latex: [["flat", "&#x266d;"]],
          omml: ["&#x266d;"],
          html: ["&#x266d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\flat"
        end

        def to_asciimath(**)
          parsing_wrapper("flat", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266d;"
        end

        def to_html(**)
          "&#x266d;"
        end
      end
    end
  end
end
