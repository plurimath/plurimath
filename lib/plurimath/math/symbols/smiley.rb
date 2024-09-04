module Plurimath
  module Math
    module Symbols
      class Smiley < Symbol
        INPUT = {
          unicodemath: [["&#x263a;"], parsing_wrapper(["smileface", "smiley"], lang: :unicode)],
          asciimath: [["&#x263a;"], parsing_wrapper(["smileface", "smiley"], lang: :asciimath)],
          mathml: ["&#x263a;"],
          latex: [["smileface", "smiley", "&#x263a;"]],
          omml: ["&#x263a;"],
          html: ["&#x263a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smileface"
        end

        def to_asciimath(**)
          parsing_wrapper("smiley", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263a;"
        end

        def to_html(**)
          "&#x263a;"
        end
      end
    end
  end
end
