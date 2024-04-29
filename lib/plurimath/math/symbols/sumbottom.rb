module Plurimath
  module Math
    module Symbols
      class Sumbottom < Symbol
        INPUT = {
          unicodemath: [["&#x23b3;"], parsing_wrapper(["sumbottom"])],
          asciimath: [["&#x23b3;"], parsing_wrapper(["sumbottom"])],
          mathml: ["&#x23b3;"],
          latex: [["sumbottom", "&#x23b3;"]],
          omml: ["&#x23b3;"],
          html: ["&#x23b3;"],
        }.freeze

        # output methods
        def to_latex
          "\\sumbottom"
        end

        def to_asciimath
          parsing_wrapper("sumbottom")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x23b3;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x23b3;"
        end

        def to_omml_without_math_tag(_)
          "&#x23b3;"
        end

        def to_html
          "&#x23b3;"
        end
      end
    end
  end
end
