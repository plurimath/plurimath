module Plurimath
  module Math
    module Symbols
      class Ulcorner < Symbol
        INPUT = {
          unicodemath: [["&#x231c;"], parsing_wrapper(["ulcorner"], lang: :unicode)],
          asciimath: [["&#x231c;"], parsing_wrapper(["ulcorner"], lang: :asciimath)],
          mathml: ["&#x231c;"],
          latex: [["ulcorner", "&#x231c;"]],
          omml: ["&#x231c;"],
          html: ["&#x231c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ulcorner"
        end

        def to_asciimath(**)
          parsing_wrapper("ulcorner", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x231c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x231c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x231c;"
        end

        def to_html(**)
          "&#x231c;"
        end
      end
    end
  end
end
