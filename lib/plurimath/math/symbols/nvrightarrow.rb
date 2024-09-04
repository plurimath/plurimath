module Plurimath
  module Math
    module Symbols
      class Nvrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2903;"], parsing_wrapper(["nvRightarrow"], lang: :unicode)],
          asciimath: [["&#x2903;"], parsing_wrapper(["nvRightarrow"], lang: :asciimath)],
          mathml: ["&#x2903;"],
          latex: [["nvRightarrow", "&#x2903;"]],
          omml: ["&#x2903;"],
          html: ["&#x2903;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvRightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nvRightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2903;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2903;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2903;"
        end

        def to_html(**)
          "&#x2903;"
        end
      end
    end
  end
end
