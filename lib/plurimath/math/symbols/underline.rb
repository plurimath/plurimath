module Plurimath
  module Math
    module Symbols
      class Underline < Symbol
        INPUT = {
          unicodemath: [["&#x332;"], parsing_wrapper(["underline"], lang: :unicode)],
          asciimath: [["&#x332;"], parsing_wrapper(["underline"], lang: :asciimath)],
          mathml: ["&#x332;"],
          latex: [["underline", "&#x332;"]],
          omml: ["&#x332;"],
          html: ["&#x332;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underline"
        end

        def to_asciimath(**)
          parsing_wrapper("underline", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x332;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x332;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x332;"
        end

        def to_html(**)
          "&#x332;"
        end
      end
    end
  end
end
