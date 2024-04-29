module Plurimath
  module Math
    module Symbols
      class Leftarrowtriangle < Symbol
        INPUT = {
          unicodemath: [["&#x21fd;"], parsing_wrapper(["leftarrowtriangle"])],
          asciimath: [["&#x21fd;"], parsing_wrapper(["leftarrowtriangle"])],
          mathml: ["&#x21fd;"],
          latex: [["leftarrowtriangle", "&#x21fd;"]],
          omml: ["&#x21fd;"],
          html: ["&#x21fd;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftarrowtriangle"
        end

        def to_asciimath
          parsing_wrapper("leftarrowtriangle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21fd;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21fd;"
        end

        def to_omml_without_math_tag(_)
          "&#x21fd;"
        end

        def to_html
          "&#x21fd;"
        end
      end
    end
  end
end
