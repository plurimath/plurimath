module Plurimath
  module Math
    module Symbols
      class Eqqslantgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2a9c;"], parsing_wrapper(["eqqslantgtr"])],
          asciimath: [["&#x2a9c;"], parsing_wrapper(["eqqslantgtr"])],
          mathml: ["&#x2a9c;"],
          latex: [["eqqslantgtr", "&#x2a9c;"]],
          omml: ["&#x2a9c;"],
          html: ["&#x2a9c;"],
        }.freeze

        # output methods
        def to_latex
          "\\eqqslantgtr"
        end

        def to_asciimath
          parsing_wrapper("eqqslantgtr")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a9c;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a9c;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a9c;"
        end

        def to_html
          "&#x2a9c;"
        end
      end
    end
  end
end
