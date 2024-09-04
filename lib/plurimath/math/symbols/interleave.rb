module Plurimath
  module Math
    module Symbols
      class Interleave < Symbol
        INPUT = {
          unicodemath: [["&#x2af4;"], parsing_wrapper(["interleave"], lang: :unicode)],
          asciimath: [["&#x2af4;"], parsing_wrapper(["interleave"], lang: :asciimath)],
          mathml: ["&#x2af4;"],
          latex: [["interleave", "&#x2af4;"]],
          omml: ["&#x2af4;"],
          html: ["&#x2af4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\interleave"
        end

        def to_asciimath(**)
          parsing_wrapper("interleave", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af4;"
        end

        def to_html(**)
          "&#x2af4;"
        end
      end
    end
  end
end
