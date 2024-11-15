module Plurimath
  module Math
    module Symbols
      class Gg < Symbol
        INPUT = {
          unicodemath: ["gg", "&#x226b;", parsing_wrapper(["mgt"], lang: :unicode)],
          asciimath: ["&#x226b;", "gg", "mgt"],
          mathml: ["&#x226b;"],
          latex: ["gg", "&#x226b;", parsing_wrapper(["mgt"], lang: :latex)],
          omml: ["&#x226b;"],
          html: ["&#x226b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gg"
        end

        def to_asciimath(**)
          "gg"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x226b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x226b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x226b;"
        end

        def to_html(**)
          "&#x226b;"
        end
      end
    end
  end
end
