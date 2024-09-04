module Plurimath
  module Math
    module Symbols
      class Nleftrightarrow < Symbol
        INPUT = {
          unicodemath: [["nLeftrightarrow", "&#x21ce;"]],
          asciimath: [["&#x21ce;"], parsing_wrapper(["nLeftrightarrow"], lang: :asciimath)],
          mathml: ["&#x21ce;"],
          latex: [["nLeftrightarrow", "&#x21ce;"]],
          omml: ["&#x21ce;"],
          html: ["&#x21ce;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nLeftrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nLeftrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21ce;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21ce;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21ce;"
        end

        def to_html(**)
          "&#x21ce;"
        end
      end
    end
  end
end
