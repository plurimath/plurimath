module Plurimath
  module Math
    module Symbols
      class Lgblkcircle < Symbol
        INPUT = {
          unicodemath: [["&#x2b24;"], parsing_wrapper(["lgblkcircle"], lang: :unicode)],
          asciimath: [["&#x2b24;"], parsing_wrapper(["lgblkcircle"], lang: :asciimath)],
          mathml: ["&#x2b24;"],
          latex: [["lgblkcircle", "&#x2b24;"]],
          omml: ["&#x2b24;"],
          html: ["&#x2b24;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgblkcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("lgblkcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b24;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b24;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b24;"
        end

        def to_html(**)
          "&#x2b24;"
        end
      end
    end
  end
end
