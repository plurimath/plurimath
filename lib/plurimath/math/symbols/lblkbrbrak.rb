module Plurimath
  module Math
    module Symbols
      class Lblkbrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x2997;"], parsing_wrapper(["lblkbrbrak"], lang: :unicode)],
          asciimath: [["&#x2997;"], parsing_wrapper(["lblkbrbrak"], lang: :asciimath)],
          mathml: ["&#x2997;"],
          latex: [["lblkbrbrak", "&#x2997;"]],
          omml: ["&#x2997;"],
          html: ["&#x2997;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lblkbrbrak"
        end

        def to_asciimath(**)
          parsing_wrapper("lblkbrbrak", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2997;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2997;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2997;"
        end

        def to_html(**)
          "&#x2997;"
        end
      end
    end
  end
end
