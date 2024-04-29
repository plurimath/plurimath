module Plurimath
  module Math
    module Symbols
      class Lparenlend < Symbol
        INPUT = {
          unicodemath: [["&#x239d;"], parsing_wrapper(["lparenlend"])],
          asciimath: [["&#x239d;"], parsing_wrapper(["lparenlend"])],
          mathml: ["&#x239d;"],
          latex: [["lparenlend", "&#x239d;"]],
          omml: ["&#x239d;"],
          html: ["&#x239d;"],
        }.freeze

        # output methods
        def to_latex
          "\\lparenlend"
        end

        def to_asciimath
          parsing_wrapper("lparenlend")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x239d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x239d;"
        end

        def to_omml_without_math_tag(_)
          "&#x239d;"
        end

        def to_html
          "&#x239d;"
        end
      end
    end
  end
end
