module Plurimath
  module Math
    module Symbols
      class Sagittarius < Symbol
        INPUT = {
          unicodemath: [["&#x2650;"], parsing_wrapper(["sagittarius"], lang: :unicode)],
          asciimath: [["&#x2650;"], parsing_wrapper(["sagittarius"], lang: :asciimath)],
          mathml: ["&#x2650;"],
          latex: [["sagittarius", "&#x2650;"]],
          omml: ["&#x2650;"],
          html: ["&#x2650;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sagittarius"
        end

        def to_asciimath(**)
          parsing_wrapper("sagittarius", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2650;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2650;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2650;"
        end

        def to_html(**)
          "&#x2650;"
        end
      end
    end
  end
end
