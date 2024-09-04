module Plurimath
  module Math
    module Symbols
      class Rightarrowplus < Symbol
        INPUT = {
          unicodemath: [["&#x2945;"], parsing_wrapper(["rightarrowplus"], lang: :unicode)],
          asciimath: [["&#x2945;"], parsing_wrapper(["rightarrowplus"], lang: :asciimath)],
          mathml: ["&#x2945;"],
          latex: [["rightarrowplus", "&#x2945;"]],
          omml: ["&#x2945;"],
          html: ["&#x2945;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowplus"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2945;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2945;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2945;"
        end

        def to_html(**)
          "&#x2945;"
        end
      end
    end
  end
end
