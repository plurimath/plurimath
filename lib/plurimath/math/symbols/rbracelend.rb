module Plurimath
  module Math
    module Symbols
      class Rbracelend < Symbol
        INPUT = {
          unicodemath: [["&#x23ad;"], parsing_wrapper(["rbracelend"])],
          asciimath: [["&#x23ad;"], parsing_wrapper(["rbracelend"])],
          mathml: ["&#x23ad;"],
          latex: [["rbracelend", "&#x23ad;"]],
          omml: ["&#x23ad;"],
          html: ["&#x23ad;"],
        }.freeze

        # output methods
        def to_latex
          "\\rbracelend"
        end

        def to_asciimath
          parsing_wrapper("rbracelend")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x23ad;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x23ad;"
        end

        def to_omml_without_math_tag(_)
          "&#x23ad;"
        end

        def to_html
          "&#x23ad;"
        end
      end
    end
  end
end
