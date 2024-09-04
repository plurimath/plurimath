module Plurimath
  module Math
    module Symbols
      class Bigstar < Symbol
        INPUT = {
          unicodemath: [["&#x2605;"], parsing_wrapper(["bigstar"], lang: :unicode)],
          asciimath: [["&#x2605;"], parsing_wrapper(["bigstar"], lang: :asciimath)],
          mathml: ["&#x2605;"],
          latex: [["bigstar", "&#x2605;"]],
          omml: ["&#x2605;"],
          html: ["&#x2605;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigstar"
        end

        def to_asciimath(**)
          parsing_wrapper("bigstar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2605;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2605;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2605;"
        end

        def to_html(**)
          "&#x2605;"
        end
      end
    end
  end
end
