module Plurimath
  module Math
    module Symbols
      class Rightanglesqr < Symbol
        INPUT = {
          unicodemath: [["&#x299c;"], parsing_wrapper(["rightanglesqr"], lang: :unicode)],
          asciimath: [["&#x299c;"], parsing_wrapper(["rightanglesqr"], lang: :asciimath)],
          mathml: ["&#x299c;"],
          latex: [["rightanglesqr", "&#x299c;"]],
          omml: ["&#x299c;"],
          html: ["&#x299c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightanglesqr"
        end

        def to_asciimath(**)
          parsing_wrapper("rightanglesqr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x299c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x299c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x299c;"
        end

        def to_html(**)
          "&#x299c;"
        end
      end
    end
  end
end
