module Plurimath
  module Math
    module Symbols
      class Mdblkdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x2b25;"], parsing_wrapper(["mdblkdiamond"], lang: :unicode)],
          asciimath: [["&#x2b25;"], parsing_wrapper(["mdblkdiamond"], lang: :asciimath)],
          mathml: ["&#x2b25;"],
          latex: [["mdblkdiamond", "&#x2b25;"]],
          omml: ["&#x2b25;"],
          html: ["&#x2b25;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdblkdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("mdblkdiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b25;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b25;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b25;"
        end

        def to_html(**)
          "&#x2b25;"
        end
      end
    end
  end
end
