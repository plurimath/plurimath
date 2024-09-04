module Plurimath
  module Math
    module Symbols
      class Leftarrowbsimilar < Symbol
        INPUT = {
          unicodemath: [["&#x2b4b;"], parsing_wrapper(["leftarrowbsimilar"], lang: :unicode)],
          asciimath: [["&#x2b4b;"], parsing_wrapper(["leftarrowbsimilar"], lang: :asciimath)],
          mathml: ["&#x2b4b;"],
          latex: [["leftarrowbsimilar", "&#x2b4b;"]],
          omml: ["&#x2b4b;"],
          html: ["&#x2b4b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowbsimilar"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowbsimilar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b4b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b4b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b4b;"
        end

        def to_html(**)
          "&#x2b4b;"
        end
      end
    end
  end
end
