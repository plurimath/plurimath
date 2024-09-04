module Plurimath
  module Math
    module Symbols
      class Danger < Symbol
        INPUT = {
          unicodemath: [["&#x2621;"], parsing_wrapper(["danger"], lang: :unicode)],
          asciimath: [["&#x2621;"], parsing_wrapper(["danger"], lang: :asciimath)],
          mathml: ["&#x2621;"],
          latex: [["danger", "&#x2621;"]],
          omml: ["&#x2621;"],
          html: ["&#x2621;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\danger"
        end

        def to_asciimath(**)
          parsing_wrapper("danger", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2621;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2621;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2621;"
        end

        def to_html(**)
          "&#x2621;"
        end
      end
    end
  end
end
