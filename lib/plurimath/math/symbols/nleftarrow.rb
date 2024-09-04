module Plurimath
  module Math
    module Symbols
      class Nleftarrow < Symbol
        INPUT = {
          unicodemath: [["nLeftarrow", "&#x21cd;"]],
          asciimath: [["&#x21cd;"], parsing_wrapper(["nLeftarrow"], lang: :asciimath)],
          mathml: ["&#x21cd;"],
          latex: [["nLeftarrow", "&#x21cd;"]],
          omml: ["&#x21cd;"],
          html: ["&#x21cd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nLeftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nLeftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21cd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21cd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21cd;"
        end

        def to_html(**)
          "&#x21cd;"
        end
      end
    end
  end
end
