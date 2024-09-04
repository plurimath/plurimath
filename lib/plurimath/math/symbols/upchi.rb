module Plurimath
  module Math
    module Symbols
      class Upchi < Symbol
        INPUT = {
          unicodemath: [["&#x3a7;"], parsing_wrapper(["upChi"], lang: :unicode)],
          asciimath: [["&#x3a7;"], parsing_wrapper(["upChi"], lang: :asciimath)],
          mathml: ["&#x3a7;"],
          latex: [["upChi", "&#x3a7;"]],
          omml: ["&#x3a7;"],
          html: ["&#x3a7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upChi"
        end

        def to_asciimath(**)
          parsing_wrapper("upChi", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3a7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a7;"
        end

        def to_html(**)
          "&#x3a7;"
        end
      end
    end
  end
end
