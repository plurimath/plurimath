module Plurimath
  module Math
    module Symbols
      class Lparenless < Symbol
        INPUT = {
          unicodemath: [["&#x2993;"], parsing_wrapper(["lparenless"], lang: :unicode)],
          asciimath: [["&#x2993;"], parsing_wrapper(["lparenless"], lang: :asciimath)],
          mathml: ["&#x2993;"],
          latex: [["lparenless", "&#x2993;"]],
          omml: ["&#x2993;"],
          html: ["&#x2993;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lparenless"
        end

        def to_asciimath(**)
          parsing_wrapper("lparenless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2993;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2993;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2993;"
        end

        def to_html(**)
          "&#x2993;"
        end
      end
    end
  end
end
