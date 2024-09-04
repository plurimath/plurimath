module Plurimath
  module Math
    module Symbols
      class Mdsmblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x25fe;"], parsing_wrapper(["mdsmblksquare"], lang: :unicode)],
          asciimath: [["&#x25fe;"], parsing_wrapper(["mdsmblksquare"], lang: :asciimath)],
          mathml: ["&#x25fe;"],
          latex: [["mdsmblksquare", "&#x25fe;"]],
          omml: ["&#x25fe;"],
          html: ["&#x25fe;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdsmblksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("mdsmblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25fe;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25fe;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25fe;"
        end

        def to_html(**)
          "&#x25fe;"
        end
      end
    end
  end
end
