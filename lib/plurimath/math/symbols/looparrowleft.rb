module Plurimath
  module Math
    module Symbols
      class Looparrowleft < Symbol
        INPUT = {
          unicodemath: [["looparrowleft", "&#x21ac;"], parsing_wrapper(["looparrowright"], lang: :unicode)],
          asciimath: [["&#x21ac;"], parsing_wrapper(["looparrowleft", "looparrowright"], lang: :asciimath)],
          mathml: ["&#x21ac;"],
          latex: [["looparrowright", "&#x21ac;"], parsing_wrapper(["looparrowleft"], lang: :latex)],
          omml: ["&#x21ac;"],
          html: ["&#x21ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\looparrowright"
        end

        def to_asciimath(**)
          parsing_wrapper("looparrowleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21ac;"
        end

        def to_html(**)
          "&#x21ac;"
        end
      end
    end
  end
end
