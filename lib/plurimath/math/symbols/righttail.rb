module Plurimath
  module Math
    module Symbols
      class Righttail < Symbol
        INPUT = {
          unicodemath: [["&#x291a;"], parsing_wrapper(["righttail"])],
          asciimath: [["&#x291a;"], parsing_wrapper(["righttail"])],
          mathml: ["&#x291a;"],
          latex: [["righttail", "&#x291a;"]],
          omml: ["&#x291a;"],
          html: ["&#x291a;"],
        }.freeze

        # output methods
        def to_latex
          "\\righttail"
        end

        def to_asciimath
          parsing_wrapper("righttail")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x291a;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x291a;"
        end

        def to_omml_without_math_tag(_)
          "&#x291a;"
        end

        def to_html
          "&#x291a;"
        end
      end
    end
  end
end
