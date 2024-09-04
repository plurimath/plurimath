module Plurimath
  module Math
    module Symbols
      class Isins < Symbol
        INPUT = {
          unicodemath: [["&#x22f4;"], parsing_wrapper(["isins"], lang: :unicode)],
          asciimath: [["&#x22f4;"], parsing_wrapper(["isins"], lang: :asciimath)],
          mathml: ["&#x22f4;"],
          latex: [["isins", "&#x22f4;"]],
          omml: ["&#x22f4;"],
          html: ["&#x22f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\isins"
        end

        def to_asciimath(**)
          parsing_wrapper("isins", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f4;"
        end

        def to_html(**)
          "&#x22f4;"
        end
      end
    end
  end
end
