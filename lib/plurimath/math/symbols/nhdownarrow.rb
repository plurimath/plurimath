module Plurimath
  module Math
    module Symbols
      class Nhdownarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21df;"], parsing_wrapper(["nHdownarrow"], lang: :unicode)],
          asciimath: [["&#x21df;"], parsing_wrapper(["nHdownarrow"], lang: :asciimath)],
          mathml: ["&#x21df;"],
          latex: [["nHdownarrow", "&#x21df;"]],
          omml: ["&#x21df;"],
          html: ["&#x21df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nHdownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nHdownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21df;"
        end

        def to_html(**)
          "&#x21df;"
        end
      end
    end
  end
end
