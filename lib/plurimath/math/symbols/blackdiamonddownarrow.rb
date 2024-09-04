module Plurimath
  module Math
    module Symbols
      class Blackdiamonddownarrow < Symbol
        INPUT = {
          unicodemath: [["&#x29ea;"], parsing_wrapper(["blackdiamonddownarrow"], lang: :unicode)],
          asciimath: [["&#x29ea;"], parsing_wrapper(["blackdiamonddownarrow"], lang: :asciimath)],
          mathml: ["&#x29ea;"],
          latex: [["blackdiamonddownarrow", "&#x29ea;"]],
          omml: ["&#x29ea;"],
          html: ["&#x29ea;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackdiamonddownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("blackdiamonddownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ea;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ea;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ea;"
        end

        def to_html(**)
          "&#x29ea;"
        end
      end
    end
  end
end
