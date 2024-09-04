module Plurimath
  module Math
    module Symbols
      class Subseteqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ac5;"], parsing_wrapper(["subseteqq"], lang: :unicode)],
          asciimath: [["&#x2ac5;"], parsing_wrapper(["subseteqq"], lang: :asciimath)],
          mathml: ["&#x2ac5;"],
          latex: [["subseteqq", "&#x2ac5;"]],
          omml: ["&#x2ac5;"],
          html: ["&#x2ac5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subseteqq"
        end

        def to_asciimath(**)
          parsing_wrapper("subseteqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac5;"
        end

        def to_html(**)
          "&#x2ac5;"
        end
      end
    end
  end
end
