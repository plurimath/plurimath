module Plurimath
  module Math
    module Symbols
      class Squoval < Symbol
        INPUT = {
          unicodemath: [["&#x25a2;"], parsing_wrapper(["squoval"])],
          asciimath: [["&#x25a2;"], parsing_wrapper(["squoval"])],
          mathml: ["&#x25a2;"],
          latex: [["squoval", "&#x25a2;"]],
          omml: ["&#x25a2;"],
          html: ["&#x25a2;"],
        }.freeze

        # output methods
        def to_latex
          "\\squoval"
        end

        def to_asciimath
          parsing_wrapper("squoval")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25a2;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25a2;"
        end

        def to_omml_without_math_tag(_)
          "&#x25a2;"
        end

        def to_html
          "&#x25a2;"
        end
      end
    end
  end
end
