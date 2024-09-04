module Plurimath
  module Math
    module Symbols
      class Mdwhtdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x2b26;"], parsing_wrapper(["mdwhtdiamond"], lang: :unicode)],
          asciimath: [["&#x2b26;"], parsing_wrapper(["mdwhtdiamond"], lang: :asciimath)],
          mathml: ["&#x2b26;"],
          latex: [["mdwhtdiamond", "&#x2b26;"]],
          omml: ["&#x2b26;"],
          html: ["&#x2b26;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdwhtdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("mdwhtdiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b26;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b26;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b26;"
        end

        def to_html(**)
          "&#x2b26;"
        end
      end
    end
  end
end
