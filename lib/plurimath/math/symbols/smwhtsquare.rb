module Plurimath
  module Math
    module Symbols
      class Smwhtsquare < Symbol
        INPUT = {
          unicodemath: [["&#x25ab;"], parsing_wrapper(["smwhtsquare"], lang: :unicode)],
          asciimath: [["&#x25ab;"], parsing_wrapper(["smwhtsquare"], lang: :asciimath)],
          mathml: ["&#x25ab;"],
          latex: [["smwhtsquare", "&#x25ab;"]],
          omml: ["&#x25ab;"],
          html: ["&#x25ab;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smwhtsquare"
        end

        def to_asciimath(**)
          parsing_wrapper("smwhtsquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ab;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ab;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ab;"
        end

        def to_html(**)
          "&#x25ab;"
        end
      end
    end
  end
end
