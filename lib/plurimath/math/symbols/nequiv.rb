module Plurimath
  module Math
    module Symbols
      class Nequiv < Symbol
        INPUT = {
          unicodemath: [["nequiv", "&#x2262;"]],
          asciimath: [["&#x2262;"], parsing_wrapper(["nequiv"], lang: :asciimath)],
          mathml: ["&#x2262;"],
          latex: [["nequiv", "&#x2262;"]],
          omml: ["&#x2262;"],
          html: ["&#x2262;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nequiv"
        end

        def to_asciimath(**)
          parsing_wrapper("nequiv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2262;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2262;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2262;"
        end

        def to_html(**)
          "&#x2262;"
        end
      end
    end
  end
end
