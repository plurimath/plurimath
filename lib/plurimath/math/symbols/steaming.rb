module Plurimath
  module Math
    module Symbols
      class Steaming < Symbol
        INPUT = {
          unicodemath: [["&#x2615;"], parsing_wrapper(["steaming"], lang: :unicode)],
          asciimath: [["&#x2615;"], parsing_wrapper(["steaming"], lang: :asciimath)],
          mathml: ["&#x2615;"],
          latex: [["steaming", "&#x2615;"]],
          omml: ["&#x2615;"],
          html: ["&#x2615;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\steaming"
        end

        def to_asciimath(**)
          parsing_wrapper("steaming", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2615;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2615;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2615;"
        end

        def to_html(**)
          "&#x2615;"
        end
      end
    end
  end
end
