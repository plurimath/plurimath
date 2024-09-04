module Plurimath
  module Math
    module Symbols
      class Lneq < Symbol
        INPUT = {
          unicodemath: [["lneq", "&#x2268;"], parsing_wrapper(["lneqq"], lang: :unicode)],
          asciimath: [["&#x2268;"], parsing_wrapper(["lneq", "lneqq"], lang: :asciimath)],
          mathml: ["&#x2268;"],
          latex: [["lneqq", "&#x2268;"], parsing_wrapper(["lneq"], lang: :latex)],
          omml: ["&#x2268;"],
          html: ["&#x2268;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("lneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2268;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2268;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2268;"
        end

        def to_html(**)
          "&#x2268;"
        end
      end
    end
  end
end
