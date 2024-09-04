module Plurimath
  module Math
    module Symbols
      class Notslash < Symbol
        INPUT = {
          unicodemath: [["&#x233f;"], parsing_wrapper(["APLnotslash", "notslash"], lang: :unicode)],
          asciimath: [["&#x233f;"], parsing_wrapper(["APLnotslash", "notslash"], lang: :asciimath)],
          mathml: ["&#x233f;"],
          latex: [["APLnotslash", "notslash", "&#x233f;"]],
          omml: ["&#x233f;"],
          html: ["&#x233f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLnotslash"
        end

        def to_asciimath(**)
          parsing_wrapper("notslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x233f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x233f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x233f;"
        end

        def to_html(**)
          "&#x233f;"
        end
      end
    end
  end
end
