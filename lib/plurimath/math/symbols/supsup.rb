module Plurimath
  module Math
    module Symbols
      class Supsup < Symbol
        INPUT = {
          unicodemath: [["supsup", "&#x2ad6;"]],
          asciimath: [["&#x2ad6;"], parsing_wrapper(["supsup"], lang: :asciimath)],
          mathml: ["&#x2ad6;"],
          latex: [["supsup", "&#x2ad6;"]],
          omml: ["&#x2ad6;"],
          html: ["&#x2ad6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsup"
        end

        def to_asciimath(**)
          parsing_wrapper("supsup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad6;"
        end

        def to_html(**)
          "&#x2ad6;"
        end
      end
    end
  end
end
