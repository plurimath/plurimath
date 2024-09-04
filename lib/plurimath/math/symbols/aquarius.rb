module Plurimath
  module Math
    module Symbols
      class Aquarius < Symbol
        INPUT = {
          unicodemath: [["&#x2652;"], parsing_wrapper(["aquarius"], lang: :unicode)],
          asciimath: [["&#x2652;"], parsing_wrapper(["aquarius"], lang: :asciimath)],
          mathml: ["&#x2652;"],
          latex: [["aquarius", "&#x2652;"]],
          omml: ["&#x2652;"],
          html: ["&#x2652;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\aquarius"
        end

        def to_asciimath(**)
          parsing_wrapper("aquarius", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2652;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2652;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2652;"
        end

        def to_html(**)
          "&#x2652;"
        end
      end
    end
  end
end
