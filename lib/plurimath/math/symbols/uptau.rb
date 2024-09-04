module Plurimath
  module Math
    module Symbols
      class Uptau < Symbol
        INPUT = {
          unicodemath: [["&#x3a4;"], parsing_wrapper(["upTau"], lang: :unicode)],
          asciimath: [["&#x3a4;"], parsing_wrapper(["upTau"], lang: :asciimath)],
          mathml: ["&#x3a4;"],
          latex: [["upTau", "&#x3a4;"]],
          omml: ["&#x3a4;"],
          html: ["&#x3a4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upTau"
        end

        def to_asciimath(**)
          parsing_wrapper("upTau", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a4;"
        end

        def to_html(**)
          "&#x3a4;"
        end
      end
    end
  end
end
