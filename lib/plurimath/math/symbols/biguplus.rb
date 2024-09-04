module Plurimath
  module Math
    module Symbols
      class Biguplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a04;"], parsing_wrapper(["biguplus"], lang: :unicode)],
          asciimath: [["&#x2a04;"], parsing_wrapper(["biguplus"], lang: :asciimath)],
          mathml: ["&#x2a04;"],
          latex: [["biguplus", "&#x2a04;"]],
          omml: ["&#x2a04;"],
          html: ["&#x2a04;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\biguplus"
        end

        def to_asciimath(**)
          parsing_wrapper("biguplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a04;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a04;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a04;"
        end

        def to_html(**)
          "&#x2a04;"
        end
      end
    end
  end
end
