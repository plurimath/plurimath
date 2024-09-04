module Plurimath
  module Math
    module Symbols
      class Neswarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2922;"], parsing_wrapper(["neswarrow"], lang: :unicode)],
          asciimath: [["&#x2922;"], parsing_wrapper(["neswarrow"], lang: :asciimath)],
          mathml: ["&#x2922;"],
          latex: [["neswarrow", "&#x2922;"]],
          omml: ["&#x2922;"],
          html: ["&#x2922;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\neswarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("neswarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2922;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2922;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2922;"
        end

        def to_html(**)
          "&#x2922;"
        end
      end
    end
  end
end
