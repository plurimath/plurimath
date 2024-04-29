module Plurimath
  module Math
    module Symbols
      class Capwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a44;"], parsing_wrapper(["capwedge"])],
          asciimath: [["&#x2a44;"], parsing_wrapper(["capwedge"])],
          mathml: ["&#x2a44;"],
          latex: [["capwedge", "&#x2a44;"]],
          omml: ["&#x2a44;"],
          html: ["&#x2a44;"],
        }.freeze

        # output methods
        def to_latex
          "\\capwedge"
        end

        def to_asciimath
          parsing_wrapper("capwedge")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a44;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a44;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a44;"
        end

        def to_html
          "&#x2a44;"
        end
      end
    end
  end
end
