module Plurimath
  module Math
    module Symbols
      class Smile < Symbol
        INPUT = {
          unicodemath: [["&#x2323;"], parsing_wrapper(["smile"])],
          asciimath: [["&#x2323;"], parsing_wrapper(["smile"])],
          mathml: ["&#x2323;"],
          latex: [["smile", "&#x2323;"]],
          omml: ["&#x2323;"],
          html: ["&#x2323;"],
        }.freeze

        # output methods
        def to_latex
          "\\smile"
        end

        def to_asciimath
          parsing_wrapper("smile")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2323;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2323;"
        end

        def to_omml_without_math_tag(_)
          "&#x2323;"
        end

        def to_html
          "&#x2323;"
        end
      end
    end
  end
end
