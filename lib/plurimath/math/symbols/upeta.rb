module Plurimath
  module Math
    module Symbols
      class Upeta < Symbol
        INPUT = {
          unicodemath: [["&#x397;"], parsing_wrapper(["upEta"], lang: :unicode)],
          asciimath: [["&#x397;"], parsing_wrapper(["upEta"], lang: :asciimath)],
          mathml: ["&#x397;"],
          latex: [["upEta", "&#x397;"]],
          omml: ["&#x397;"],
          html: ["&#x397;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upEta"
        end

        def to_asciimath(**)
          parsing_wrapper("upEta", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x397;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x397;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x397;"
        end

        def to_html(**)
          "&#x397;"
        end
      end
    end
  end
end
