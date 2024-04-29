module Plurimath
  module Math
    module Symbols
      class Succcurlyeq < Symbol
        INPUT = {
          unicodemath: [["succcurlyeq", "&#x227d;"], parsing_wrapper(["SucceedsSlantEqual"])],
          asciimath: [["&#x227d;"], parsing_wrapper(["succcurlyeq", "SucceedsSlantEqual"])],
          mathml: ["&#x227d;"],
          latex: [["SucceedsSlantEqual", "succcurlyeq", "&#x227d;"]],
          omml: ["&#x227d;"],
          html: ["&#x227d;"],
        }.freeze

        # output methods
        def to_latex
          "\\SucceedsSlantEqual"
        end

        def to_asciimath
          parsing_wrapper("succcurlyeq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x227d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x227d;"
        end

        def to_omml_without_math_tag(_)
          "&#x227d;"
        end

        def to_html
          "&#x227d;"
        end
      end
    end
  end
end
