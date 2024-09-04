module Plurimath
  module Math
    module Symbols
      class Parsim < Symbol
        INPUT = {
          unicodemath: [["&#x2af3;"], parsing_wrapper(["parsim"], lang: :unicode)],
          asciimath: [["&#x2af3;"], parsing_wrapper(["parsim"], lang: :asciimath)],
          mathml: ["&#x2af3;"],
          latex: [["parsim", "&#x2af3;"]],
          omml: ["&#x2af3;"],
          html: ["&#x2af3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\parsim"
        end

        def to_asciimath(**)
          parsing_wrapper("parsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af3;"
        end

        def to_html(**)
          "&#x2af3;"
        end
      end
    end
  end
end
