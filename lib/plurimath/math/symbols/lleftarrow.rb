module Plurimath
  module Math
    module Symbols
      class Lleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b45;"], parsing_wrapper(["LLeftarrow"], lang: :unicode)],
          asciimath: [["&#x2b45;"], parsing_wrapper(["LLeftarrow"], lang: :asciimath)],
          mathml: ["&#x2b45;"],
          latex: [["LLeftarrow", "&#x2b45;"]],
          omml: ["&#x2b45;"],
          html: ["&#x2b45;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\LLeftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("LLeftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b45;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b45;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b45;"
        end

        def to_html(**)
          "&#x2b45;"
        end
      end
    end
  end
end
