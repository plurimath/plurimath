module Plurimath
  module Math
    module Symbols
      class Biginterleave < Symbol
        INPUT = {
          unicodemath: [["&#x2afc;"], parsing_wrapper(["biginterleave"], lang: :unicode)],
          asciimath: [["&#x2afc;"], parsing_wrapper(["biginterleave"], lang: :asciimath)],
          mathml: ["&#x2afc;"],
          latex: [["biginterleave", "&#x2afc;"]],
          omml: ["&#x2afc;"],
          html: ["&#x2afc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\biginterleave"
        end

        def to_asciimath(**)
          parsing_wrapper("biginterleave", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2afc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2afc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2afc;"
        end

        def to_html(**)
          "&#x2afc;"
        end
      end
    end
  end
end
