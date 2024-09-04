module Plurimath
  module Math
    module Symbols
      class Eqsim < Symbol
        INPUT = {
          unicodemath: [["&#x2242;"], parsing_wrapper(["eqsim"], lang: :unicode)],
          asciimath: [["&#x2242;"], parsing_wrapper(["eqsim"], lang: :asciimath)],
          mathml: ["&#x2242;"],
          latex: [["eqsim", "&#x2242;"]],
          omml: ["&#x2242;"],
          html: ["&#x2242;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqsim"
        end

        def to_asciimath(**)
          parsing_wrapper("eqsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2242;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2242;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2242;"
        end

        def to_html(**)
          "&#x2242;"
        end
      end
    end
  end
end
