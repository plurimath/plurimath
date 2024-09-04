module Plurimath
  module Math
    module Symbols
      class Ocommatopright < Symbol
        INPUT = {
          unicodemath: [["&#x315;"], parsing_wrapper(["ocommatopright"], lang: :unicode)],
          asciimath: [["&#x315;"], parsing_wrapper(["ocommatopright"], lang: :asciimath)],
          mathml: ["&#x315;"],
          latex: [["ocommatopright", "&#x315;"]],
          omml: ["&#x315;"],
          html: ["&#x315;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ocommatopright"
        end

        def to_asciimath(**)
          parsing_wrapper("ocommatopright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x315;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x315;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x315;"
        end

        def to_html(**)
          "&#x315;"
        end
      end
    end
  end
end
