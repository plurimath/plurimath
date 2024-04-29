module Plurimath
  module Math
    module Symbols
      class Intcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a19;"], parsing_wrapper(["intcap"])],
          asciimath: [["&#x2a19;"], parsing_wrapper(["intcap"])],
          mathml: ["&#x2a19;"],
          latex: [["intcap", "&#x2a19;"]],
          omml: ["&#x2a19;"],
          html: ["&#x2a19;"],
        }.freeze

        # output methods
        def to_latex
          "\\intcap"
        end

        def to_asciimath
          parsing_wrapper("intcap")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a19;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a19;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a19;"
        end

        def to_html
          "&#x2a19;"
        end
      end
    end
  end
end
