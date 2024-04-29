module Plurimath
  module Math
    module Symbols
      class Blackinwhitediamond < Symbol
        INPUT = {
          unicodemath: [["&#x25c8;"], parsing_wrapper(["blackinwhitediamond"])],
          asciimath: [["&#x25c8;"], parsing_wrapper(["blackinwhitediamond"])],
          mathml: ["&#x25c8;"],
          latex: [["blackinwhitediamond", "&#x25c8;"]],
          omml: ["&#x25c8;"],
          html: ["&#x25c8;"],
        }.freeze

        # output methods
        def to_latex
          "\\blackinwhitediamond"
        end

        def to_asciimath
          parsing_wrapper("blackinwhitediamond")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25c8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25c8;"
        end

        def to_omml_without_math_tag(_)
          "&#x25c8;"
        end

        def to_html
          "&#x25c8;"
        end
      end
    end
  end
end
