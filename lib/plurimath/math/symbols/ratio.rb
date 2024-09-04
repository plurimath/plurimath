module Plurimath
  module Math
    module Symbols
      class Ratio < Symbol
        INPUT = {
          unicodemath: [["propto", "ratio", "&#x221d;"], parsing_wrapper(["prop"], lang: :unicode)],
          asciimath: [["propto", "prop", "&#x221d;"], parsing_wrapper(["ratio"], lang: :asciimath)],
          mathml: ["&#x221d;"],
          latex: [["propto", "&#x221d;"], parsing_wrapper(["ratio", "prop"], lang: :latex)],
          omml: ["&#x221d;"],
          html: ["&#x221d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\propto"
        end

        def to_asciimath(**)
          parsing_wrapper("ratio", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x221d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x221d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x221d;"
        end

        def to_html(**)
          "&#x221d;"
        end
      end
    end
  end
end
