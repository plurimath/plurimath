module Plurimath
  module Math
    module Symbols
      class Otimeshat < Symbol
        INPUT = {
          unicodemath: [["&#x2a36;"], parsing_wrapper(["otimeshat"], lang: :unicode)],
          asciimath: [["&#x2a36;"], parsing_wrapper(["otimeshat"], lang: :asciimath)],
          mathml: ["&#x2a36;"],
          latex: [["otimeshat", "&#x2a36;"]],
          omml: ["&#x2a36;"],
          html: ["&#x2a36;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\otimeshat"
        end

        def to_asciimath(**)
          parsing_wrapper("otimeshat", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a36;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a36;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a36;"
        end

        def to_html(**)
          "&#x2a36;"
        end
      end
    end
  end
end
