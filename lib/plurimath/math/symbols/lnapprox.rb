module Plurimath
  module Math
    module Symbols
      class Lnapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2a89;"], parsing_wrapper(["lnapprox"], lang: :unicode)],
          asciimath: [["&#x2a89;"], parsing_wrapper(["lnapprox"], lang: :asciimath)],
          mathml: ["&#x2a89;"],
          latex: [["lnapprox", "&#x2a89;"]],
          omml: ["&#x2a89;"],
          html: ["&#x2a89;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lnapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("lnapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a89;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a89;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a89;"
        end

        def to_html(**)
          "&#x2a89;"
        end
      end
    end
  end
end
