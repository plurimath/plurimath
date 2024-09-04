module Plurimath
  module Math
    module Symbols
      class Veeeq < Symbol
        INPUT = {
          unicodemath: [["&#x225a;"], parsing_wrapper(["veeeq"], lang: :unicode)],
          asciimath: [["&#x225a;"], parsing_wrapper(["veeeq"], lang: :asciimath)],
          mathml: ["&#x225a;"],
          latex: [["veeeq", "&#x225a;"]],
          omml: ["&#x225a;"],
          html: ["&#x225a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veeeq"
        end

        def to_asciimath(**)
          parsing_wrapper("veeeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x225a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x225a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x225a;"
        end

        def to_html(**)
          "&#x225a;"
        end
      end
    end
  end
end
