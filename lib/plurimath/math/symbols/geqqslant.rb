module Plurimath
  module Math
    module Symbols
      class Geqqslant < Symbol
        INPUT = {
          unicodemath: [["&#x2afa;"], parsing_wrapper(["geqqslant"], lang: :unicode)],
          asciimath: [["&#x2afa;"], parsing_wrapper(["geqqslant"], lang: :asciimath)],
          mathml: ["&#x2afa;"],
          latex: [["geqqslant", "&#x2afa;"]],
          omml: ["&#x2afa;"],
          html: ["&#x2afa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\geqqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("geqqslant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2afa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2afa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2afa;"
        end

        def to_html(**)
          "&#x2afa;"
        end
      end
    end
  end
end
