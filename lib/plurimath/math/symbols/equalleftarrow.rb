module Plurimath
  module Math
    module Symbols
      class Equalleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b40;"], parsing_wrapper(["equalleftarrow"], lang: :unicode)],
          asciimath: [["&#x2b40;"], parsing_wrapper(["equalleftarrow"], lang: :asciimath)],
          mathml: ["&#x2b40;"],
          latex: [["equalleftarrow", "&#x2b40;"]],
          omml: ["&#x2b40;"],
          html: ["&#x2b40;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equalleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("equalleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b40;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b40;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b40;"
        end

        def to_html(**)
          "&#x2b40;"
        end
      end
    end
  end
end
