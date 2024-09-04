module Plurimath
  module Math
    module Symbols
      class Epar < Symbol
        INPUT = {
          unicodemath: [["epar", "&#x22e5;"], parsing_wrapper(["sqsupsetneq"], lang: :unicode)],
          asciimath: [["&#x22e5;"], parsing_wrapper(["epar", "sqsupsetneq"], lang: :asciimath)],
          mathml: ["&#x22e5;"],
          latex: [["sqsupsetneq", "&#x22e5;"], parsing_wrapper(["epar"], lang: :latex)],
          omml: ["&#x22e5;"],
          html: ["&#x22e5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsupsetneq"
        end

        def to_asciimath(**)
          parsing_wrapper("epar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e5;"
        end

        def to_html(**)
          "&#x22e5;"
        end
      end
    end
  end
end
