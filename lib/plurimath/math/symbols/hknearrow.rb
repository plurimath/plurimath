module Plurimath
  module Math
    module Symbols
      class Hknearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2924;"], parsing_wrapper(["hknearrow"], lang: :unicode)],
          asciimath: [["&#x2924;"], parsing_wrapper(["hknearrow"], lang: :asciimath)],
          mathml: ["&#x2924;"],
          latex: [["hknearrow", "&#x2924;"]],
          omml: ["&#x2924;"],
          html: ["&#x2924;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hknearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("hknearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2924;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2924;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2924;"
        end

        def to_html(**)
          "&#x2924;"
        end
      end
    end
  end
end
