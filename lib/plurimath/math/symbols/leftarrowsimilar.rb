module Plurimath
  module Math
    module Symbols
      class Leftarrowsimilar < Symbol
        INPUT = {
          unicodemath: [["&#x2973;"], parsing_wrapper(["leftarrowsimilar"], lang: :unicode)],
          asciimath: [["&#x2973;"], parsing_wrapper(["leftarrowsimilar"], lang: :asciimath)],
          mathml: ["&#x2973;"],
          latex: [["leftarrowsimilar", "&#x2973;"]],
          omml: ["&#x2973;"],
          html: ["&#x2973;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowsimilar"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowsimilar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2973;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2973;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2973;"
        end

        def to_html(**)
          "&#x2973;"
        end
      end
    end
  end
end
