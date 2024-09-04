module Plurimath
  module Math
    module Symbols
      class Nlessgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2278;"], parsing_wrapper(["nlessgtr"], lang: :unicode)],
          asciimath: [["&#x2278;"], parsing_wrapper(["nlessgtr"], lang: :asciimath)],
          mathml: ["&#x2278;"],
          latex: [["nlessgtr", "&#x2278;"]],
          omml: ["&#x2278;"],
          html: ["&#x2278;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nlessgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("nlessgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2278;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2278;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2278;"
        end

        def to_html(**)
          "&#x2278;"
        end
      end
    end
  end
end
