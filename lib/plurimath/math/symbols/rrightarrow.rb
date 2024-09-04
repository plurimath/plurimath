module Plurimath
  module Math
    module Symbols
      class Rrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b46;"], parsing_wrapper(["RRightarrow"], lang: :unicode)],
          asciimath: [["&#x2b46;"], parsing_wrapper(["RRightarrow"], lang: :asciimath)],
          mathml: ["&#x2b46;"],
          latex: [["RRightarrow", "&#x2b46;"]],
          omml: ["&#x2b46;"],
          html: ["&#x2b46;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\RRightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("RRightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b46;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b46;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b46;"
        end

        def to_html(**)
          "&#x2b46;"
        end
      end
    end
  end
end
