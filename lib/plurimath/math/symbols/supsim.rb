module Plurimath
  module Math
    module Symbols
      class Supsim < Symbol
        INPUT = {
          unicodemath: [["&#x2ac8;"], parsing_wrapper(["supsim"], lang: :unicode)],
          asciimath: [["&#x2ac8;"], parsing_wrapper(["supsim"], lang: :asciimath)],
          mathml: ["&#x2ac8;"],
          latex: [["supsim", "&#x2ac8;"]],
          omml: ["&#x2ac8;"],
          html: ["&#x2ac8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsim"
        end

        def to_asciimath(**)
          parsing_wrapper("supsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac8;"
        end

        def to_html(**)
          "&#x2ac8;"
        end
      end
    end
  end
end
