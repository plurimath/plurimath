module Plurimath
  module Math
    module Symbols
      class Rightarrowbsimilar < Symbol
        INPUT = {
          unicodemath: [["&#x2b4c;"], parsing_wrapper(["rightarrowbsimilar"], lang: :unicode)],
          asciimath: [["&#x2b4c;"], parsing_wrapper(["rightarrowbsimilar"], lang: :asciimath)],
          mathml: ["&#x2b4c;"],
          latex: [["rightarrowbsimilar", "&#x2b4c;"]],
          omml: ["&#x2b4c;"],
          html: ["&#x2b4c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowbsimilar"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowbsimilar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b4c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b4c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b4c;"
        end

        def to_html(**)
          "&#x2b4c;"
        end
      end
    end
  end
end
