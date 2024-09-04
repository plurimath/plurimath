module Plurimath
  module Math
    module Symbols
      class Subrarr < Symbol
        INPUT = {
          unicodemath: [["&#x2979;"], parsing_wrapper(["subrarr"], lang: :unicode)],
          asciimath: [["&#x2979;"], parsing_wrapper(["subrarr"], lang: :asciimath)],
          mathml: ["&#x2979;"],
          latex: [["subrarr", "&#x2979;"]],
          omml: ["&#x2979;"],
          html: ["&#x2979;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subrarr"
        end

        def to_asciimath(**)
          parsing_wrapper("subrarr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2979;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2979;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2979;"
        end

        def to_html(**)
          "&#x2979;"
        end
      end
    end
  end
end
