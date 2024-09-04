module Plurimath
  module Math
    module Symbols
      class Subsim < Symbol
        INPUT = {
          unicodemath: [["&#x2ac7;"], parsing_wrapper(["subsim"], lang: :unicode)],
          asciimath: [["&#x2ac7;"], parsing_wrapper(["subsim"], lang: :asciimath)],
          mathml: ["&#x2ac7;"],
          latex: [["subsim", "&#x2ac7;"]],
          omml: ["&#x2ac7;"],
          html: ["&#x2ac7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsim"
        end

        def to_asciimath(**)
          parsing_wrapper("subsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac7;"
        end

        def to_html(**)
          "&#x2ac7;"
        end
      end
    end
  end
end
