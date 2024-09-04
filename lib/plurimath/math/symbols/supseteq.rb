module Plurimath
  module Math
    module Symbols
      class Supseteq < Symbol
        INPUT = {
          unicodemath: [["supseteq", "&#x2287;"], parsing_wrapper(["supe"], lang: :unicode)],
          asciimath: [["supseteq", "supe", "&#x2287;"]],
          mathml: ["&#x2287;"],
          latex: [["supseteq", "&#x2287;"], parsing_wrapper(["supe"], lang: :latex)],
          omml: ["&#x2287;"],
          html: ["&#x2287;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("supseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2287;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2287;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2287;"
        end

        def to_html(**)
          "&#x2287;"
        end
      end
    end
  end
end
