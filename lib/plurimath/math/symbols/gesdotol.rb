module Plurimath
  module Math
    module Symbols
      class Gesdotol < Symbol
        INPUT = {
          unicodemath: [["&#x2a84;"], parsing_wrapper(["gesdotol"], lang: :unicode)],
          asciimath: [["&#x2a84;"], parsing_wrapper(["gesdotol"], lang: :asciimath)],
          mathml: ["&#x2a84;"],
          latex: [["gesdotol", "&#x2a84;"]],
          omml: ["&#x2a84;"],
          html: ["&#x2a84;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gesdotol"
        end

        def to_asciimath(**)
          parsing_wrapper("gesdotol", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a84;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a84;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a84;"
        end

        def to_html(**)
          "&#x2a84;"
        end
      end
    end
  end
end
