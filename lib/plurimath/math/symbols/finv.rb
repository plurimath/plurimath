module Plurimath
  module Math
    module Symbols
      class Finv < Symbol
        INPUT = {
          unicodemath: [["&#x2132;"], parsing_wrapper(["Finv"], lang: :unicode)],
          asciimath: [["&#x2132;"], parsing_wrapper(["Finv"], lang: :asciimath)],
          mathml: ["&#x2132;"],
          latex: [["Finv", "&#x2132;"]],
          omml: ["&#x2132;"],
          html: ["&#x2132;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Finv"
        end

        def to_asciimath(**)
          parsing_wrapper("Finv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2132;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2132;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2132;"
        end

        def to_html(**)
          "&#x2132;"
        end
      end
    end
  end
end
