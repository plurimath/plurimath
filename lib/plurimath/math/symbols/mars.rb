module Plurimath
  module Math
    module Symbols
      class Mars < Symbol
        INPUT = {
          unicodemath: [["&#x2642;"], parsing_wrapper(["male", "Mars"], lang: :unicode)],
          asciimath: [["&#x2642;"], parsing_wrapper(["male", "Mars"], lang: :asciimath)],
          mathml: ["&#x2642;"],
          latex: [["male", "Mars", "&#x2642;"]],
          omml: ["&#x2642;"],
          html: ["&#x2642;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\male"
        end

        def to_asciimath(**)
          parsing_wrapper("Mars", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2642;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2642;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2642;"
        end

        def to_html(**)
          "&#x2642;"
        end
      end
    end
  end
end
