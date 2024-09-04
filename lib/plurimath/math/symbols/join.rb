module Plurimath
  module Math
    module Symbols
      class Join < Symbol
        INPUT = {
          unicodemath: [["&#x2a1d;"], parsing_wrapper(["Join"], lang: :unicode)],
          asciimath: [["&#x2a1d;"], parsing_wrapper(["Join"], lang: :asciimath)],
          mathml: ["&#x2a1d;"],
          latex: [["Join", "&#x2a1d;"]],
          omml: ["&#x2a1d;"],
          html: ["&#x2a1d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Join"
        end

        def to_asciimath(**)
          parsing_wrapper("Join", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a1d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a1d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a1d;"
        end

        def to_html(**)
          "&#x2a1d;"
        end
      end
    end
  end
end
