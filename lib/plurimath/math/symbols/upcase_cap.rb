module Plurimath
  module Math
    module Symbols
      class UpcaseCap < Symbol
        INPUT = {
          unicodemath: [["Cap", "&#x22d2;"]],
          asciimath: [["&#x22d2;"], parsing_wrapper(["Cap"], lang: :asciimath)],
          mathml: ["&#x22d2;"],
          latex: [["Cap", "&#x22d2;"]],
          omml: ["&#x22d2;"],
          html: ["&#x22d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Cap"
        end

        def to_asciimath(**)
          parsing_wrapper("Cap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d2;"
        end

        def to_html(**)
          "&#x22d2;"
        end
      end
    end
  end
end
