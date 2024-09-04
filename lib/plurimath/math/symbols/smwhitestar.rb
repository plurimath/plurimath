module Plurimath
  module Math
    module Symbols
      class Smwhitestar < Symbol
        INPUT = {
          unicodemath: [["&#x2b52;"], parsing_wrapper(["smwhitestar"], lang: :unicode)],
          asciimath: [["&#x2b52;"], parsing_wrapper(["smwhitestar"], lang: :asciimath)],
          mathml: ["&#x2b52;"],
          latex: [["smwhitestar", "&#x2b52;"]],
          omml: ["&#x2b52;"],
          html: ["&#x2b52;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smwhitestar"
        end

        def to_asciimath(**)
          parsing_wrapper("smwhitestar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b52;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b52;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b52;"
        end

        def to_html(**)
          "&#x2b52;"
        end
      end
    end
  end
end
