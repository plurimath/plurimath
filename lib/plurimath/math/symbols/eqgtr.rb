module Plurimath
  module Math
    module Symbols
      class Eqgtr < Symbol
        INPUT = {
          unicodemath: [["eqgtr", "&#x22dd;"]],
          asciimath: [["&#x22dd;"], parsing_wrapper(["eqgtr"], lang: :asciimath)],
          mathml: ["&#x22dd;"],
          latex: [["eqgtr", "&#x22dd;"]],
          omml: ["&#x22dd;"],
          html: ["&#x22dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("eqgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22dd;"
        end

        def to_html(**)
          "&#x22dd;"
        end
      end
    end
  end
end
