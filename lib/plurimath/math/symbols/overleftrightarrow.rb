module Plurimath
  module Math
    module Symbols
      class Overleftrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x20e1;"], parsing_wrapper(["overleftrightarrow"], lang: :unicode)],
          asciimath: [["&#x20e1;"], parsing_wrapper(["overleftrightarrow"], lang: :asciimath)],
          mathml: ["&#x20e1;"],
          latex: [["overleftrightarrow", "&#x20e1;"]],
          omml: ["&#x20e1;"],
          html: ["&#x20e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\overleftrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("overleftrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20e1;"
        end

        def to_html(**)
          "&#x20e1;"
        end
      end
    end
  end
end
