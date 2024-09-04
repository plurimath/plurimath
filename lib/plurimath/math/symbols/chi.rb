module Plurimath
  module Math
    module Symbols
      class Chi < Symbol
        INPUT = {
          unicodemath: [["chi", "&#x3c7;"], parsing_wrapper(["upchi"], lang: :unicode)],
          asciimath: [["chi", "&#x3c7;"], parsing_wrapper(["upchi"], lang: :asciimath)],
          mathml: ["&#x3c7;"],
          latex: [["upchi", "chi", "&#x3c7;"]],
          omml: ["&#x3c7;"],
          html: ["&#x3c7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\chi"
        end

        def to_asciimath(**)
          "chi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c7;"
        end

        def to_html(**)
          "&#x3c7;"
        end
      end
    end
  end
end
