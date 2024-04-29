module Plurimath
  module Math
    module Symbols
      class Rbrackuend < Symbol
        INPUT = {
          unicodemath: [["&#x23a4;"], parsing_wrapper(["rbrackuend"])],
          asciimath: [["&#x23a4;"], parsing_wrapper(["rbrackuend"])],
          mathml: ["&#x23a4;"],
          latex: [["rbrackuend", "&#x23a4;"]],
          omml: ["&#x23a4;"],
          html: ["&#x23a4;"],
        }.freeze

        # output methods
        def to_latex
          "\\rbrackuend"
        end

        def to_asciimath
          parsing_wrapper("rbrackuend")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x23a4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x23a4;"
        end

        def to_omml_without_math_tag(_)
          "&#x23a4;"
        end

        def to_html
          "&#x23a4;"
        end
      end
    end
  end
end
