module Plurimath
  module Math
    module Symbols
      class Plus < Symbol
        INPUT = {
          unicodemath: [["&#x2b;", "+"], parsing_wrapper(["plus"], lang: :unicode)],
          asciimath: [["&#x2b;", "+"], parsing_wrapper(["plus"], lang: :asciimath)],
          mathml: ["&#x2b;", "+"],
          latex: [["plus", "+", "&#x2b;"]],
          omml: ["&#x2b;", "+"],
          html: ["&#x2b;", "+"],
        }.freeze

        # output methods
        def to_latex(**)
          "+"
        end

        def to_asciimath(**)
          "+"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("+")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "+"
        end

        def to_omml_without_math_tag(_, **)
          "+"
        end

        def to_html(**)
          "&#x2b;"
        end
      end
    end
  end
end
