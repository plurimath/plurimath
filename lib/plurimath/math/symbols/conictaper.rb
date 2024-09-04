module Plurimath
  module Math
    module Symbols
      class Conictaper < Symbol
        INPUT = {
          unicodemath: [["&#x2332;"], parsing_wrapper(["conictaper"], lang: :unicode)],
          asciimath: [["&#x2332;"], parsing_wrapper(["conictaper"], lang: :asciimath)],
          mathml: ["&#x2332;"],
          latex: [["conictaper", "&#x2332;"]],
          omml: ["&#x2332;"],
          html: ["&#x2332;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\conictaper"
        end

        def to_asciimath(**)
          parsing_wrapper("conictaper", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2332;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2332;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2332;"
        end

        def to_html(**)
          "&#x2332;"
        end
      end
    end
  end
end
