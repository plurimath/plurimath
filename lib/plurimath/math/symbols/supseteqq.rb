module Plurimath
  module Math
    module Symbols
      class Supseteqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ac6;"], parsing_wrapper(["supseteqq"], lang: :unicode)],
          asciimath: [["&#x2ac6;"], parsing_wrapper(["supseteqq"], lang: :asciimath)],
          mathml: ["&#x2ac6;"],
          latex: [["supseteqq", "&#x2ac6;"]],
          omml: ["&#x2ac6;"],
          html: ["&#x2ac6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supseteqq"
        end

        def to_asciimath(**)
          parsing_wrapper("supseteqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac6;"
        end

        def to_html(**)
          "&#x2ac6;"
        end
      end
    end
  end
end
