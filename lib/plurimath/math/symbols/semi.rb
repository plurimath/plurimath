module Plurimath
  module Math
    module Symbols
      class Semi < Symbol
        INPUT = {
          unicodemath: [["&#x2a1f;"], parsing_wrapper(["zcmp", "semi"])],
          asciimath: [["&#x2a1f;"], parsing_wrapper(["zcmp", "semi"])],
          mathml: ["&#x2a1f;"],
          latex: [["zcmp", "semi", "&#x2a1f;"]],
          omml: ["&#x2a1f;"],
          html: ["&#x2a1f;"],
        }.freeze

        # output methods
        def to_latex
          "\\zcmp"
        end

        def to_asciimath
          parsing_wrapper("semi")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a1f;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a1f;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a1f;"
        end

        def to_html
          "&#x2a1f;"
        end
      end
    end
  end
end
