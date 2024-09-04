module Plurimath
  module Math
    module Symbols
      class Commaminus < Symbol
        INPUT = {
          unicodemath: [["&#x2a29;"], parsing_wrapper(["commaminus"], lang: :unicode)],
          asciimath: [["&#x2a29;"], parsing_wrapper(["commaminus"], lang: :asciimath)],
          mathml: ["&#x2a29;"],
          latex: [["commaminus", "&#x2a29;"]],
          omml: ["&#x2a29;"],
          html: ["&#x2a29;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\commaminus"
        end

        def to_asciimath(**)
          parsing_wrapper("commaminus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a29;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a29;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a29;"
        end

        def to_html(**)
          "&#x2a29;"
        end
      end
    end
  end
end
