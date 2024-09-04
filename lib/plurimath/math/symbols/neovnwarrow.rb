module Plurimath
  module Math
    module Symbols
      class Neovnwarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2931;"], parsing_wrapper(["neovnwarrow"], lang: :unicode)],
          asciimath: [["&#x2931;"], parsing_wrapper(["neovnwarrow"], lang: :asciimath)],
          mathml: ["&#x2931;"],
          latex: [["neovnwarrow", "&#x2931;"]],
          omml: ["&#x2931;"],
          html: ["&#x2931;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\neovnwarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("neovnwarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2931;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2931;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2931;"
        end

        def to_html(**)
          "&#x2931;"
        end
      end
    end
  end
end
