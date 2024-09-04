module Plurimath
  module Math
    module Symbols
      class Scorpio < Symbol
        INPUT = {
          unicodemath: [["&#x264f;"], parsing_wrapper(["scorpio", "Scorpio"], lang: :unicode)],
          asciimath: [["&#x264f;"], parsing_wrapper(["scorpio", "Scorpio"], lang: :asciimath)],
          mathml: ["&#x264f;"],
          latex: [["scorpio", "Scorpio", "&#x264f;"]],
          omml: ["&#x264f;"],
          html: ["&#x264f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\scorpio"
        end

        def to_asciimath(**)
          parsing_wrapper("Scorpio", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x264f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x264f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x264f;"
        end

        def to_html(**)
          "&#x264f;"
        end
      end
    end
  end
end
