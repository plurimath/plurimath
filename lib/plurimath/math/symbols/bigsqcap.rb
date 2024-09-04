module Plurimath
  module Math
    module Symbols
      class Bigsqcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a05;"], parsing_wrapper(["bigsqcap"], lang: :unicode)],
          asciimath: [["&#x2a05;"], parsing_wrapper(["bigsqcap"], lang: :asciimath)],
          mathml: ["&#x2a05;"],
          latex: [["bigsqcap", "&#x2a05;"]],
          omml: ["&#x2a05;"],
          html: ["&#x2a05;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigsqcap"
        end

        def to_asciimath(**)
          parsing_wrapper("bigsqcap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a05;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a05;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a05;"
        end

        def to_html(**)
          "&#x2a05;"
        end
      end
    end
  end
end
