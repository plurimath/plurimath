module Plurimath
  module Math
    module Symbols
      class Turnediota < Symbol
        INPUT = {
          unicodemath: [["&#x2129;"], parsing_wrapper(["turnediota"], lang: :unicode)],
          asciimath: [["&#x2129;"], parsing_wrapper(["turnediota"], lang: :asciimath)],
          mathml: ["&#x2129;"],
          latex: [["turnediota", "&#x2129;"]],
          omml: ["&#x2129;"],
          html: ["&#x2129;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\turnediota"
        end

        def to_asciimath(**)
          parsing_wrapper("turnediota", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2129;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2129;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2129;"
        end

        def to_html(**)
          "&#x2129;"
        end
      end
    end
  end
end
