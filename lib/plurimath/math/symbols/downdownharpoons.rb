module Plurimath
  module Math
    module Symbols
      class Downdownharpoons < Symbol
        INPUT = {
          unicodemath: [["&#x2965;"], parsing_wrapper(["downharpoonsleftright", "downdownharpoons"], lang: :unicode)],
          asciimath: [["&#x2965;"], parsing_wrapper(["downharpoonsleftright", "downdownharpoons"], lang: :asciimath)],
          mathml: ["&#x2965;"],
          latex: [["downharpoonsleftright", "downdownharpoons", "&#x2965;"]],
          omml: ["&#x2965;"],
          html: ["&#x2965;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downharpoonsleftright"
        end

        def to_asciimath(**)
          parsing_wrapper("downdownharpoons", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2965;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2965;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2965;"
        end

        def to_html(**)
          "&#x2965;"
        end
      end
    end
  end
end
