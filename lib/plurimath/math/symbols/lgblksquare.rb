module Plurimath
  module Math
    module Symbols
      class Lgblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x2b1b;"], parsing_wrapper(["lgblksquare"], lang: :unicode)],
          asciimath: [["&#x2b1b;"], parsing_wrapper(["lgblksquare"], lang: :asciimath)],
          mathml: ["&#x2b1b;"],
          latex: [["lgblksquare", "&#x2b1b;"]],
          omml: ["&#x2b1b;"],
          html: ["&#x2b1b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgblksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("lgblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b1b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b1b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b1b;"
        end

        def to_html(**)
          "&#x2b1b;"
        end
      end
    end
  end
end
