module Plurimath
  module Math
    module Symbols
      class Rightarrowapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2975;"], parsing_wrapper(["rightarrowapprox"])],
          asciimath: [["&#x2975;"], parsing_wrapper(["rightarrowapprox"])],
          mathml: ["&#x2975;"],
          latex: [["rightarrowapprox", "&#x2975;"]],
          omml: ["&#x2975;"],
          html: ["&#x2975;"],
        }.freeze

        # output methods
        def to_latex
          "\\rightarrowapprox"
        end

        def to_asciimath
          parsing_wrapper("rightarrowapprox")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2975;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2975;"
        end

        def to_omml_without_math_tag(_)
          "&#x2975;"
        end

        def to_html
          "&#x2975;"
        end
      end
    end
  end
end
