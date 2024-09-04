module Plurimath
  module Math
    module Symbols
      class Rightarrowshortleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2942;"], parsing_wrapper(["rightarrowshortleftarrow"], lang: :unicode)],
          asciimath: [["&#x2942;"], parsing_wrapper(["rightarrowshortleftarrow"], lang: :asciimath)],
          mathml: ["&#x2942;"],
          latex: [["rightarrowshortleftarrow", "&#x2942;"]],
          omml: ["&#x2942;"],
          html: ["&#x2942;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowshortleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowshortleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2942;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2942;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2942;"
        end

        def to_html(**)
          "&#x2942;"
        end
      end
    end
  end
end
