module Plurimath
  module Math
    module Symbols
      class Exi < Symbol
        INPUT = {
          unicodemath: [["exists", "&#x2203;"], parsing_wrapper(["EE", "exi"])],
          asciimath: [["exists", "EE", "&#x2203;"], parsing_wrapper(["exi"])],
          mathml: ["&#x2203;"],
          latex: [["exists", "exi", "&#x2203;"], parsing_wrapper(["EE"])],
          omml: ["&#x2203;"],
          html: ["&#x2203;"],
        }.freeze

        # output methods
        def to_latex
          "\\exists"
        end

        def to_asciimath
          parsing_wrapper("exi")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2203;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2203;"
        end

        def to_omml_without_math_tag(_)
          "&#x2203;"
        end

        def to_html
          "&#x2203;"
        end
      end
    end
  end
end
