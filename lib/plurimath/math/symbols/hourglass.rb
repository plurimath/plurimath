module Plurimath
  module Math
    module Symbols
      class Hourglass < Symbol
        INPUT = {
          unicodemath: [["&#x29d6;"], parsing_wrapper(["hourglass"], lang: :unicode)],
          asciimath: [["&#x29d6;"], parsing_wrapper(["hourglass"], lang: :asciimath)],
          mathml: ["&#x29d6;"],
          latex: [["hourglass", "&#x29d6;"]],
          omml: ["&#x29d6;"],
          html: ["&#x29d6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hourglass"
        end

        def to_asciimath(**)
          parsing_wrapper("hourglass", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29d6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29d6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29d6;"
        end

        def to_html(**)
          "&#x29d6;"
        end
      end
    end
  end
end
