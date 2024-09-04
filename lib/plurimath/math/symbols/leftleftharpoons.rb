module Plurimath
  module Math
    module Symbols
      class Leftleftharpoons < Symbol
        INPUT = {
          unicodemath: [["&#x2962;"], parsing_wrapper(["leftharpoonsupdown", "leftleftharpoons"], lang: :unicode)],
          asciimath: [["&#x2962;"], parsing_wrapper(["leftharpoonsupdown", "leftleftharpoons"], lang: :asciimath)],
          mathml: ["&#x2962;"],
          latex: [["leftharpoonsupdown", "leftleftharpoons", "&#x2962;"]],
          omml: ["&#x2962;"],
          html: ["&#x2962;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftharpoonsupdown"
        end

        def to_asciimath(**)
          parsing_wrapper("leftleftharpoons", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2962;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2962;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2962;"
        end

        def to_html(**)
          "&#x2962;"
        end
      end
    end
  end
end
