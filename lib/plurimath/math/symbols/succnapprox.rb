module Plurimath
  module Math
    module Symbols
      class Succnapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2aba;"], parsing_wrapper(["succnapprox"], lang: :unicode)],
          asciimath: [["&#x2aba;"], parsing_wrapper(["succnapprox"], lang: :asciimath)],
          mathml: ["&#x2aba;"],
          latex: [["succnapprox", "&#x2aba;"]],
          omml: ["&#x2aba;"],
          html: ["&#x2aba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succnapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("succnapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aba;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aba;"
        end

        def to_html(**)
          "&#x2aba;"
        end
      end
    end
  end
end
