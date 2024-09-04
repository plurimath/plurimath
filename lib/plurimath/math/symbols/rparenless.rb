module Plurimath
  module Math
    module Symbols
      class Rparenless < Symbol
        INPUT = {
          unicodemath: [["&#x2996;"], parsing_wrapper(["Rparenless"], lang: :unicode)],
          asciimath: [["&#x2996;"], parsing_wrapper(["Rparenless"], lang: :asciimath)],
          mathml: ["&#x2996;"],
          latex: [["Rparenless", "&#x2996;"]],
          omml: ["&#x2996;"],
          html: ["&#x2996;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Rparenless"
        end

        def to_asciimath(**)
          parsing_wrapper("Rparenless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2996;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2996;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2996;"
        end

        def to_html(**)
          "&#x2996;"
        end
      end
    end
  end
end
