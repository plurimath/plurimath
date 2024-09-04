module Plurimath
  module Math
    module Symbols
      class Threeunderdot < Symbol
        INPUT = {
          unicodemath: [["&#x20e8;"], parsing_wrapper(["threeunderdot"], lang: :unicode)],
          asciimath: [["&#x20e8;"], parsing_wrapper(["threeunderdot"], lang: :asciimath)],
          mathml: ["&#x20e8;"],
          latex: [["threeunderdot", "&#x20e8;"]],
          omml: ["&#x20e8;"],
          html: ["&#x20e8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\threeunderdot"
        end

        def to_asciimath(**)
          parsing_wrapper("threeunderdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20e8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20e8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20e8;"
        end

        def to_html(**)
          "&#x20e8;"
        end
      end
    end
  end
end
