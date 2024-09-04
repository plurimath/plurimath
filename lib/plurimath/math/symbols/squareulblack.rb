module Plurimath
  module Math
    module Symbols
      class Squareulblack < Symbol
        INPUT = {
          unicodemath: [["&#x25e9;"], parsing_wrapper(["squareulblack"], lang: :unicode)],
          asciimath: [["&#x25e9;"], parsing_wrapper(["squareulblack"], lang: :asciimath)],
          mathml: ["&#x25e9;"],
          latex: [["squareulblack", "&#x25e9;"]],
          omml: ["&#x25e9;"],
          html: ["&#x25e9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squareulblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squareulblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e9;"
        end

        def to_html(**)
          "&#x25e9;"
        end
      end
    end
  end
end
