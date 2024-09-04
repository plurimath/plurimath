module Plurimath
  module Math
    module Symbols
      class Rightmoon < Symbol
        INPUT = {
          unicodemath: [["&#x263d;"], parsing_wrapper(["rightmoon"], lang: :unicode)],
          asciimath: [["&#x263d;"], parsing_wrapper(["rightmoon"], lang: :asciimath)],
          mathml: ["&#x263d;"],
          latex: [["rightmoon", "&#x263d;"]],
          omml: ["&#x263d;"],
          html: ["&#x263d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightmoon"
        end

        def to_asciimath(**)
          parsing_wrapper("rightmoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263d;"
        end

        def to_html(**)
          "&#x263d;"
        end
      end
    end
  end
end
