module Plurimath
  module Math
    module Symbols
      class Cupvee < Symbol
        INPUT = {
          unicodemath: [["&#x2a45;"], parsing_wrapper(["cupvee"])],
          asciimath: [["&#x2a45;"], parsing_wrapper(["cupvee"])],
          mathml: ["&#x2a45;"],
          latex: [["cupvee", "&#x2a45;"]],
          omml: ["&#x2a45;"],
          html: ["&#x2a45;"],
        }.freeze

        # output methods
        def to_latex
          "\\cupvee"
        end

        def to_asciimath
          parsing_wrapper("cupvee")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a45;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a45;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a45;"
        end

        def to_html
          "&#x2a45;"
        end
      end
    end
  end
end
