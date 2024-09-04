module Plurimath
  module Math
    module Symbols
      class Lgwhtsquare < Symbol
        INPUT = {
          unicodemath: [["&#x2b1c;"], parsing_wrapper(["lgwhtsquare"], lang: :unicode)],
          asciimath: [["&#x2b1c;"], parsing_wrapper(["lgwhtsquare"], lang: :asciimath)],
          mathml: ["&#x2b1c;"],
          latex: [["lgwhtsquare", "&#x2b1c;"]],
          omml: ["&#x2b1c;"],
          html: ["&#x2b1c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgwhtsquare"
        end

        def to_asciimath(**)
          parsing_wrapper("lgwhtsquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b1c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b1c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b1c;"
        end

        def to_html(**)
          "&#x2b1c;"
        end
      end
    end
  end
end
