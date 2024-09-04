module Plurimath
  module Math
    module Symbols
      class Hline < Symbol
        INPUT = {
          unicodemath: [["&#x23af;"], parsing_wrapper(["harrowextender", "hline"], lang: :unicode)],
          asciimath: [["&#x23af;"], parsing_wrapper(["harrowextender", "hline"], lang: :asciimath)],
          mathml: ["&#x23af;"],
          latex: [["harrowextender", "hline", "&#x23af;"]],
          omml: ["&#x23af;"],
          html: ["&#x23af;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hline"
        end

        def to_asciimath(**)
          parsing_wrapper("hline", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23af;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23af;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23af;"
        end

        def to_html(**)
          "&#x23af;"
        end
      end
    end
  end
end
