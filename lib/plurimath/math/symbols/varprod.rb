module Plurimath
  module Math
    module Symbols
      class Varprod < Symbol
        INPUT = {
          unicodemath: [["&#x2a09;"], parsing_wrapper(["bigtimes", "varprod"], lang: :unicode)],
          asciimath: [["&#x2a09;"], parsing_wrapper(["bigtimes", "varprod"], lang: :asciimath)],
          mathml: ["&#x2a09;"],
          latex: [["bigtimes", "varprod", "&#x2a09;"]],
          omml: ["&#x2a09;"],
          html: ["&#x2a09;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigtimes"
        end

        def to_asciimath(**)
          parsing_wrapper("varprod", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a09;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a09;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a09;"
        end

        def to_html(**)
          "&#x2a09;"
        end
      end
    end
  end
end
