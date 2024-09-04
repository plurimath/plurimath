module Plurimath
  module Math
    module Symbols
      class Swords < Symbol
        INPUT = {
          unicodemath: [["&#x2694;"], parsing_wrapper(["swords"], lang: :unicode)],
          asciimath: [["&#x2694;"], parsing_wrapper(["swords"], lang: :asciimath)],
          mathml: ["&#x2694;"],
          latex: [["swords", "&#x2694;"]],
          omml: ["&#x2694;"],
          html: ["&#x2694;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\swords"
        end

        def to_asciimath(**)
          parsing_wrapper("swords", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2694;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2694;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2694;"
        end

        def to_html(**)
          "&#x2694;"
        end
      end
    end
  end
end
