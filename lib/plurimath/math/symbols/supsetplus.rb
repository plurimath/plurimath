module Plurimath
  module Math
    module Symbols
      class Supsetplus < Symbol
        INPUT = {
          unicodemath: [["&#x2ac0;"], parsing_wrapper(["supsetplus"], lang: :unicode)],
          asciimath: [["&#x2ac0;"], parsing_wrapper(["supsetplus"], lang: :asciimath)],
          mathml: ["&#x2ac0;"],
          latex: [["supsetplus", "&#x2ac0;"]],
          omml: ["&#x2ac0;"],
          html: ["&#x2ac0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsetplus"
        end

        def to_asciimath(**)
          parsing_wrapper("supsetplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac0;"
        end

        def to_html(**)
          "&#x2ac0;"
        end
      end
    end
  end
end
