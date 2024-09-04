module Plurimath
  module Math
    module Symbols
      class Dotsminusdots < Symbol
        INPUT = {
          unicodemath: [["&#x223a;"], parsing_wrapper(["dotsminusdots"], lang: :unicode)],
          asciimath: [["&#x223a;"], parsing_wrapper(["dotsminusdots"], lang: :asciimath)],
          mathml: ["&#x223a;"],
          latex: [["dotsminusdots", "&#x223a;"]],
          omml: ["&#x223a;"],
          html: ["&#x223a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dotsminusdots"
        end

        def to_asciimath(**)
          parsing_wrapper("dotsminusdots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x223a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x223a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x223a;"
        end

        def to_html(**)
          "&#x223a;"
        end
      end
    end
  end
end
