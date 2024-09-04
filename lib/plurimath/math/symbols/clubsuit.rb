module Plurimath
  module Math
    module Symbols
      class Clubsuit < Symbol
        INPUT = {
          unicodemath: [["clubsuit", "&#x2663;"]],
          asciimath: [["&#x2663;"], parsing_wrapper(["clubsuit"], lang: :asciimath)],
          mathml: ["&#x2663;"],
          latex: [["clubsuit", "&#x2663;"]],
          omml: ["&#x2663;"],
          html: ["&#x2663;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\clubsuit"
        end

        def to_asciimath(**)
          parsing_wrapper("clubsuit", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2663;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2663;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2663;"
        end

        def to_html(**)
          "&#x2663;"
        end
      end
    end
  end
end
