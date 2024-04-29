module Plurimath
  module Math
    module Symbols
      class Yinyang < Symbol
        INPUT = {
          unicodemath: [["&#x262f;"], parsing_wrapper(["yinyang"])],
          asciimath: [["&#x262f;"], parsing_wrapper(["yinyang"])],
          mathml: ["&#x262f;"],
          latex: [["yinyang", "&#x262f;"]],
          omml: ["&#x262f;"],
          html: ["&#x262f;"],
        }.freeze

        # output methods
        def to_latex
          "\\yinyang"
        end

        def to_asciimath
          parsing_wrapper("yinyang")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x262f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x262f;"
        end

        def to_omml_without_math_tag(_)
          "&#x262f;"
        end

        def to_html
          "&#x262f;"
        end
      end
    end
  end
end
