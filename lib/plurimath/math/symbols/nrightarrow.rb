module Plurimath
  module Math
    module Symbols
      class Nrightarrow < Symbol
        INPUT = {
          unicodemath: [["nRightarrow", "&#x21cf;"]],
          asciimath: [["&#x21cf;"], parsing_wrapper(["nRightarrow"], lang: :asciimath)],
          mathml: ["&#x21cf;"],
          latex: [["nRightarrow", "&#x21cf;"]],
          omml: ["&#x21cf;"],
          html: ["&#x21cf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nRightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nRightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21cf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21cf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21cf;"
        end

        def to_html(**)
          "&#x21cf;"
        end
      end
    end
  end
end
