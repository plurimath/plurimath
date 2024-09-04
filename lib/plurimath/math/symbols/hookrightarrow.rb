module Plurimath
  module Math
    module Symbols
      class Hookrightarrow < Symbol
        INPUT = {
          unicodemath: [["hookrightarrow", "&#x21aa;"]],
          asciimath: [["&#x21aa;"], parsing_wrapper(["hookrightarrow"], lang: :asciimath)],
          mathml: ["&#x21aa;"],
          latex: [["hookrightarrow", "&#x21aa;"]],
          omml: ["&#x21aa;"],
          html: ["&#x21aa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hookrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("hookrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21aa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21aa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21aa;"
        end

        def to_html(**)
          "&#x21aa;"
        end
      end
    end
  end
end
