module Plurimath
  module Math
    module Symbols
      class Rightarrowtail < Symbol
        INPUT = {
          unicodemath: [["rightarrowtail", "&#x21a3;"], parsing_wrapper([">->", "tinj"], lang: :unicode)],
          asciimath: [["rightarrowtail", ">->", "&#x21a3;"], parsing_wrapper(["tinj"], lang: :asciimath)],
          mathml: ["&#x21a3;"],
          latex: [["rightarrowtail", "tinj", "&#x21a3;"], parsing_wrapper([">->"], lang: :latex)],
          omml: ["&#x21a3;"],
          html: ["&#x21a3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowtail"
        end

        def to_asciimath(**)
          "rightarrowtail"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a3;"
        end

        def to_html(**)
          "&#x21a3;"
        end
      end
    end
  end
end
