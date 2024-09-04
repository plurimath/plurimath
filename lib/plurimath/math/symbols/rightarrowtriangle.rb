module Plurimath
  module Math
    module Symbols
      class Rightarrowtriangle < Symbol
        INPUT = {
          unicodemath: [["&#x21fe;"], parsing_wrapper(["rightarrowtriangle"], lang: :unicode)],
          asciimath: [["&#x21fe;"], parsing_wrapper(["rightarrowtriangle"], lang: :asciimath)],
          mathml: ["&#x21fe;"],
          latex: [["rightarrowtriangle", "&#x21fe;"]],
          omml: ["&#x21fe;"],
          html: ["&#x21fe;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowtriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowtriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21fe;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21fe;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21fe;"
        end

        def to_html(**)
          "&#x21fe;"
        end
      end
    end
  end
end
