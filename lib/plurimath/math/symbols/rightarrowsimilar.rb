module Plurimath
  module Math
    module Symbols
      class Rightarrowsimilar < Symbol
        INPUT = {
          unicodemath: [["&#x2974;"], parsing_wrapper(["rightarrowsimilar"], lang: :unicode)],
          asciimath: [["&#x2974;"], parsing_wrapper(["rightarrowsimilar"], lang: :asciimath)],
          mathml: ["&#x2974;"],
          latex: [["rightarrowsimilar", "&#x2974;"]],
          omml: ["&#x2974;"],
          html: ["&#x2974;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowsimilar"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowsimilar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2974;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2974;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2974;"
        end

        def to_html(**)
          "&#x2974;"
        end
      end
    end
  end
end
