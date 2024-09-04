module Plurimath
  module Math
    module Symbols
      class Ominus < Symbol
        INPUT = {
          unicodemath: [["ominus", "&#x2296;"]],
          asciimath: [["&#x2296;"], parsing_wrapper(["ominus"], lang: :asciimath)],
          mathml: ["&#x2296;"],
          latex: [["ominus", "&#x2296;"]],
          omml: ["&#x2296;"],
          html: ["&#x2296;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ominus"
        end

        def to_asciimath(**)
          parsing_wrapper("ominus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2296;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2296;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2296;"
        end

        def to_html(**)
          "&#x2296;"
        end
      end
    end
  end
end
