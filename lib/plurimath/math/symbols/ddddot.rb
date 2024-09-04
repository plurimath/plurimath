module Plurimath
  module Math
    module Symbols
      class Ddddot < Symbol
        INPUT = {
          unicodemath: [["&#x20dc;"], parsing_wrapper(["ddddot"], lang: :unicode)],
          asciimath: [["&#x20dc;"], parsing_wrapper(["ddddot"], lang: :asciimath)],
          mathml: ["&#x20dc;"],
          latex: [["ddddot", "&#x20dc;"]],
          omml: ["&#x20dc;"],
          html: ["&#x20dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ddddot"
        end

        def to_asciimath(**)
          parsing_wrapper("ddddot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20dc;"
        end

        def to_html(**)
          "&#x20dc;"
        end
      end
    end
  end
end
