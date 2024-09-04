module Plurimath
  module Math
    module Symbols
      class Gtlpar < Symbol
        INPUT = {
          unicodemath: [["&#x29a0;"], parsing_wrapper(["gtlpar"], lang: :unicode)],
          asciimath: [["&#x29a0;"], parsing_wrapper(["gtlpar"], lang: :asciimath)],
          mathml: ["&#x29a0;"],
          latex: [["gtlpar", "&#x29a0;"]],
          omml: ["&#x29a0;"],
          html: ["&#x29a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtlpar"
        end

        def to_asciimath(**)
          parsing_wrapper("gtlpar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a0;"
        end

        def to_html(**)
          "&#x29a0;"
        end
      end
    end
  end
end
