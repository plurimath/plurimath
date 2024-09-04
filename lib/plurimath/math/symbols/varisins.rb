module Plurimath
  module Math
    module Symbols
      class Varisins < Symbol
        INPUT = {
          unicodemath: [["&#x22f3;"], parsing_wrapper(["varisins"], lang: :unicode)],
          asciimath: [["&#x22f3;"], parsing_wrapper(["varisins"], lang: :asciimath)],
          mathml: ["&#x22f3;"],
          latex: [["varisins", "&#x22f3;"]],
          omml: ["&#x22f3;"],
          html: ["&#x22f3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varisins"
        end

        def to_asciimath(**)
          parsing_wrapper("varisins", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f3;"
        end

        def to_html(**)
          "&#x22f3;"
        end
      end
    end
  end
end
