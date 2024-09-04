module Plurimath
  module Math
    module Symbols
      class Rightarrowgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2b43;"], parsing_wrapper(["rightarrowgtr"], lang: :unicode)],
          asciimath: [["&#x2b43;"], parsing_wrapper(["rightarrowgtr"], lang: :asciimath)],
          mathml: ["&#x2b43;"],
          latex: [["rightarrowgtr", "&#x2b43;"]],
          omml: ["&#x2b43;"],
          html: ["&#x2b43;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b43;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b43;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b43;"
        end

        def to_html(**)
          "&#x2b43;"
        end
      end
    end
  end
end
