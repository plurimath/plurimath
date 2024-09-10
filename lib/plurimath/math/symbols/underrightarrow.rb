module Plurimath
  module Math
    module Symbols
      class Underrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x20ef;"], parsing_wrapper(["underrightarrow"], lang: :unicode)],
          asciimath: [["&#x20ef;"], parsing_wrapper(["underrightarrow"], lang: :asciimath)],
          mathml: ["&#x20ef;"],
          latex: [["underrightarrow", "&#x20ef;"]],
          omml: ["&#x20ef;"],
          html: ["&#x20ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("underrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20ef;"
        end

        def to_html(**)
          "&#x20ef;"
        end
      end
    end
  end
end
