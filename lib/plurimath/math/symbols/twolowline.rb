module Plurimath
  module Math
    module Symbols
      class Twolowline < Symbol
        INPUT = {
          unicodemath: [["&#x2017;"], parsing_wrapper(["twolowline"], lang: :unicode)],
          asciimath: [["&#x2017;"], parsing_wrapper(["twolowline"], lang: :asciimath)],
          mathml: ["&#x2017;"],
          latex: [["twolowline", "&#x2017;"]],
          omml: ["&#x2017;"],
          html: ["&#x2017;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twolowline"
        end

        def to_asciimath(**)
          parsing_wrapper("twolowline", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2017;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2017;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2017;"
        end

        def to_html(**)
          "&#x2017;"
        end
      end
    end
  end
end
