module Plurimath
  module Math
    module Symbols
      class Toea < Symbol
        INPUT = {
          unicodemath: [["&#x2928;"], parsing_wrapper(["toea"], lang: :unicode)],
          asciimath: [["&#x2928;"], parsing_wrapper(["toea"], lang: :asciimath)],
          mathml: ["&#x2928;"],
          latex: [["toea", "&#x2928;"]],
          omml: ["&#x2928;"],
          html: ["&#x2928;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\toea"
        end

        def to_asciimath(**)
          parsing_wrapper("toea", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2928;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2928;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2928;"
        end

        def to_html(**)
          "&#x2928;"
        end
      end
    end
  end
end
