module Plurimath
  module Math
    module Symbols
      class Bigsqcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a06;"], parsing_wrapper(["bigsqcup"], lang: :unicode)],
          asciimath: [["&#x2a06;"], parsing_wrapper(["bigsqcup"], lang: :asciimath)],
          mathml: ["&#x2a06;"],
          latex: [["bigsqcup", "&#x2a06;"]],
          omml: ["&#x2a06;"],
          html: ["&#x2a06;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigsqcup"
        end

        def to_asciimath(**)
          parsing_wrapper("bigsqcup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a06;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a06;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a06;"
        end

        def to_html(**)
          "&#x2a06;"
        end
      end
    end
  end
end
