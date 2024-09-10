module Plurimath
  module Math
    module Symbols
      class Underleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x20ee;"], parsing_wrapper(["underleftarrow"], lang: :unicode)],
          asciimath: [["&#x20ee;"], parsing_wrapper(["underleftarrow"], lang: :asciimath)],
          mathml: ["&#x20ee;"],
          latex: [["underleftarrow", "&#x20ee;"]],
          omml: ["&#x20ee;"],
          html: ["&#x20ee;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("underleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20ee;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20ee;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20ee;"
        end

        def to_html(**)
          "&#x20ee;"
        end
      end
    end
  end
end
