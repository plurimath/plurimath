module Plurimath
  module Math
    module Symbols
      class Looparrowleft < Symbol
        INPUT = {
          unicodemath: [["looparrowleft", "&#x21ac;"], parsing_wrapper(["looparrowright"])],
          asciimath: [["&#x21ac;"], parsing_wrapper(["looparrowleft", "looparrowright"])],
          mathml: ["&#x21ac;"],
          latex: [["looparrowright", "&#x21ac;"], parsing_wrapper(["looparrowleft"])],
          omml: ["&#x21ac;"],
          html: ["&#x21ac;"],
        }.freeze

        # output methods
        def to_latex
          "\\looparrowright"
        end

        def to_asciimath
          parsing_wrapper("looparrowleft")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21ac;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21ac;"
        end

        def to_omml_without_math_tag(_)
          "&#x21ac;"
        end

        def to_html
          "&#x21ac;"
        end
      end
    end
  end
end
