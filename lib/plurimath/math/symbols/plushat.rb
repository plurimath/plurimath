module Plurimath
  module Math
    module Symbols
      class Plushat < Symbol
        INPUT = {
          unicodemath: [["&#x2a23;"], parsing_wrapper(["plushat"], lang: :unicode)],
          asciimath: [["&#x2a23;"], parsing_wrapper(["plushat"], lang: :asciimath)],
          mathml: ["&#x2a23;"],
          latex: [["plushat", "&#x2a23;"]],
          omml: ["&#x2a23;"],
          html: ["&#x2a23;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\plushat"
        end

        def to_asciimath(**)
          parsing_wrapper("plushat", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a23;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a23;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a23;"
        end

        def to_html(**)
          "&#x2a23;"
        end
      end
    end
  end
end
