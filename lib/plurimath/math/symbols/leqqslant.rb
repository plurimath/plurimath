module Plurimath
  module Math
    module Symbols
      class Leqqslant < Symbol
        INPUT = {
          unicodemath: [["&#x2af9;"], parsing_wrapper(["leqqslant"], lang: :unicode)],
          asciimath: [["&#x2af9;"], parsing_wrapper(["leqqslant"], lang: :asciimath)],
          mathml: ["&#x2af9;"],
          latex: [["leqqslant", "&#x2af9;"]],
          omml: ["&#x2af9;"],
          html: ["&#x2af9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leqqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("leqqslant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af9;"
        end

        def to_html(**)
          "&#x2af9;"
        end
      end
    end
  end
end
