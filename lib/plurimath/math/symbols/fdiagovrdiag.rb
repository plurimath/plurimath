module Plurimath
  module Math
    module Symbols
      class Fdiagovrdiag < Symbol
        INPUT = {
          unicodemath: [["&#x292c;"], parsing_wrapper(["fdiagovrdiag"], lang: :unicode)],
          asciimath: [["&#x292c;"], parsing_wrapper(["fdiagovrdiag"], lang: :asciimath)],
          mathml: ["&#x292c;"],
          latex: [["fdiagovrdiag", "&#x292c;"]],
          omml: ["&#x292c;"],
          html: ["&#x292c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fdiagovrdiag"
        end

        def to_asciimath(**)
          parsing_wrapper("fdiagovrdiag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x292c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x292c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x292c;"
        end

        def to_html(**)
          "&#x292c;"
        end
      end
    end
  end
end
