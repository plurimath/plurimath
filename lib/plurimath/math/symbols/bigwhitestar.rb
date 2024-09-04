module Plurimath
  module Math
    module Symbols
      class Bigwhitestar < Symbol
        INPUT = {
          unicodemath: [["&#x2606;"], parsing_wrapper(["bigwhitestar"], lang: :unicode)],
          asciimath: [["&#x2606;"], parsing_wrapper(["bigwhitestar"], lang: :asciimath)],
          mathml: ["&#x2606;"],
          latex: [["bigwhitestar", "&#x2606;"]],
          omml: ["&#x2606;"],
          html: ["&#x2606;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigwhitestar"
        end

        def to_asciimath(**)
          parsing_wrapper("bigwhitestar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2606;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2606;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2606;"
        end

        def to_html(**)
          "&#x2606;"
        end
      end
    end
  end
end
