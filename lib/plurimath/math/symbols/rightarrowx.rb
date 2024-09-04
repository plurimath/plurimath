module Plurimath
  module Math
    module Symbols
      class Rightarrowx < Symbol
        INPUT = {
          unicodemath: [["&#x2947;"], parsing_wrapper(["rightarrowx"], lang: :unicode)],
          asciimath: [["&#x2947;"], parsing_wrapper(["rightarrowx"], lang: :asciimath)],
          mathml: ["&#x2947;"],
          latex: [["rightarrowx", "&#x2947;"]],
          omml: ["&#x2947;"],
          html: ["&#x2947;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowx"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowx", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2947;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2947;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2947;"
        end

        def to_html(**)
          "&#x2947;"
        end
      end
    end
  end
end
