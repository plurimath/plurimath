module Plurimath
  module Math
    module Symbols
      class Cupbarcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a48;"], parsing_wrapper(["cupbarcap"], lang: :unicode)],
          asciimath: [["&#x2a48;"], parsing_wrapper(["cupbarcap"], lang: :asciimath)],
          mathml: ["&#x2a48;"],
          latex: [["cupbarcap", "&#x2a48;"]],
          omml: ["&#x2a48;"],
          html: ["&#x2a48;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cupbarcap"
        end

        def to_asciimath(**)
          parsing_wrapper("cupbarcap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a48;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a48;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a48;"
        end

        def to_html(**)
          "&#x2a48;"
        end
      end
    end
  end
end
