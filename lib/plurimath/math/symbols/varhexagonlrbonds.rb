module Plurimath
  module Math
    module Symbols
      class Varhexagonlrbonds < Symbol
        INPUT = {
          unicodemath: [["&#x232c;"], parsing_wrapper(["varhexagonlrbonds"], lang: :unicode)],
          asciimath: [["&#x232c;"], parsing_wrapper(["varhexagonlrbonds"], lang: :asciimath)],
          mathml: ["&#x232c;"],
          latex: [["varhexagonlrbonds", "&#x232c;"]],
          omml: ["&#x232c;"],
          html: ["&#x232c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varhexagonlrbonds"
        end

        def to_asciimath(**)
          parsing_wrapper("varhexagonlrbonds", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x232c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x232c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x232c;"
        end

        def to_html(**)
          "&#x232c;"
        end
      end
    end
  end
end
