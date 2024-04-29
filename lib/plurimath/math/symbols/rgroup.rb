module Plurimath
  module Math
    module Symbols
      class Rgroup < Symbol
        INPUT = {
          unicodemath: [["&#x27ef;"], parsing_wrapper(["rgroup"])],
          asciimath: [["&#x27ef;"], parsing_wrapper(["rgroup"])],
          mathml: ["&#x27ef;"],
          latex: [["rgroup", "&#x27ef;"]],
          omml: ["&#x27ef;"],
          html: ["&#x27ef;"],
        }.freeze

        # output methods
        def to_latex
          "\\rgroup"
        end

        def to_asciimath
          parsing_wrapper("rgroup")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27ef;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27ef;"
        end

        def to_omml_without_math_tag(_)
          "&#x27ef;"
        end

        def to_html
          "&#x27ef;"
        end
      end
    end
  end
end
