module Plurimath
  module Math
    module Symbols
      class Downarrowbar < Symbol
        INPUT = {
          unicodemath: [["&#x2913;"], parsing_wrapper(["DownArrowBar", "downarrowbar"], lang: :unicode)],
          asciimath: [["&#x2913;"], parsing_wrapper(["DownArrowBar", "downarrowbar"], lang: :asciimath)],
          mathml: ["&#x2913;"],
          latex: [["DownArrowBar", "downarrowbar", "&#x2913;"]],
          omml: ["&#x2913;"],
          html: ["&#x2913;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\DownArrowBar"
        end

        def to_asciimath(**)
          parsing_wrapper("downarrowbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2913;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2913;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2913;"
        end

        def to_html(**)
          "&#x2913;"
        end
      end
    end
  end
end
