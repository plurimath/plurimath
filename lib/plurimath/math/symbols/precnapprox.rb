module Plurimath
  module Math
    module Symbols
      class Precnapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2ab9;"], parsing_wrapper(["precnapprox"], lang: :unicode)],
          asciimath: [["&#x2ab9;"], parsing_wrapper(["precnapprox"], lang: :asciimath)],
          mathml: ["&#x2ab9;"],
          latex: [["precnapprox", "&#x2ab9;"]],
          omml: ["&#x2ab9;"],
          html: ["&#x2ab9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\precnapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("precnapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab9;"
        end

        def to_html(**)
          "&#x2ab9;"
        end
      end
    end
  end
end
