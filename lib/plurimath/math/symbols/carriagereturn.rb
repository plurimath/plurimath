module Plurimath
  module Math
    module Symbols
      class Carriagereturn < Symbol
        INPUT = {
          unicodemath: [["&#x21b5;"], parsing_wrapper(["carriagereturn"])],
          asciimath: [["&#x21b5;"], parsing_wrapper(["carriagereturn"])],
          mathml: ["&#x21b5;"],
          latex: [["carriagereturn", "&#x21b5;"]],
          omml: ["&#x21b5;"],
          html: ["&#x21b5;"],
        }.freeze

        # output methods
        def to_latex
          "\\carriagereturn"
        end

        def to_asciimath
          parsing_wrapper("carriagereturn")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21b5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21b5;"
        end

        def to_omml_without_math_tag(_)
          "&#x21b5;"
        end

        def to_html
          "&#x21b5;"
        end
      end
    end
  end
end
