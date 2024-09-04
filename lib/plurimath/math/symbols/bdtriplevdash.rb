module Plurimath
  module Math
    module Symbols
      class Bdtriplevdash < Symbol
        INPUT = {
          unicodemath: [["&#x2506;"], parsing_wrapper(["bdtriplevdash"], lang: :unicode)],
          asciimath: [["&#x2506;"], parsing_wrapper(["bdtriplevdash"], lang: :asciimath)],
          mathml: ["&#x2506;"],
          latex: [["bdtriplevdash", "&#x2506;"]],
          omml: ["&#x2506;"],
          html: ["&#x2506;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bdtriplevdash"
        end

        def to_asciimath(**)
          parsing_wrapper("bdtriplevdash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2506;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2506;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2506;"
        end

        def to_html(**)
          "&#x2506;"
        end
      end
    end
  end
end
