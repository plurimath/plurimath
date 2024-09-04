module Plurimath
  module Math
    module Symbols
      class Dddot < Symbol
        INPUT = {
          unicodemath: [["&#x20db;"], parsing_wrapper(["dddot", "DDDot"], lang: :unicode)],
          asciimath: [["&#x20db;"], parsing_wrapper(["dddot", "DDDot"], lang: :asciimath)],
          mathml: ["&#x20db;"],
          latex: [["dddot", "DDDot", "&#x20db;"]],
          omml: ["&#x20db;"],
          html: ["&#x20db;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dddot"
        end

        def to_asciimath(**)
          parsing_wrapper("DDDot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20db;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20db;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20db;"
        end

        def to_html(**)
          "&#x20db;"
        end
      end
    end
  end
end
