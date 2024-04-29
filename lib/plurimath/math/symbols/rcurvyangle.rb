module Plurimath
  module Math
    module Symbols
      class Rcurvyangle < Symbol
        INPUT = {
          unicodemath: [["&#x29fd;"], parsing_wrapper(["rcurvyangle"])],
          asciimath: [["&#x29fd;"], parsing_wrapper(["rcurvyangle"])],
          mathml: ["&#x29fd;"],
          latex: [["rcurvyangle", "&#x29fd;"]],
          omml: ["&#x29fd;"],
          html: ["&#x29fd;"],
        }.freeze

        # output methods
        def to_latex
          "\\rcurvyangle"
        end

        def to_asciimath
          parsing_wrapper("rcurvyangle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29fd;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29fd;"
        end

        def to_omml_without_math_tag(_)
          "&#x29fd;"
        end

        def to_html
          "&#x29fd;"
        end
      end
    end
  end
end
