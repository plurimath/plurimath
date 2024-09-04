module Plurimath
  module Math
    module Symbols
      class Updownharpoonleftright < Symbol
        INPUT = {
          unicodemath: [["&#x294d;"], parsing_wrapper(["updownharpoonleftright"], lang: :unicode)],
          asciimath: [["&#x294d;"], parsing_wrapper(["updownharpoonleftright"], lang: :asciimath)],
          mathml: ["&#x294d;"],
          latex: [["updownharpoonleftright", "&#x294d;"]],
          omml: ["&#x294d;"],
          html: ["&#x294d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updownharpoonleftright"
        end

        def to_asciimath(**)
          parsing_wrapper("updownharpoonleftright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x294d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x294d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x294d;"
        end

        def to_html(**)
          "&#x294d;"
        end
      end
    end
  end
end
