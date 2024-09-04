module Plurimath
  module Math
    module Symbols
      class Blacksmiley < Symbol
        INPUT = {
          unicodemath: [["&#x263b;"], parsing_wrapper(["invsmileface", "blacksmiley"], lang: :unicode)],
          asciimath: [["&#x263b;"], parsing_wrapper(["invsmileface", "blacksmiley"], lang: :asciimath)],
          mathml: ["&#x263b;"],
          latex: [["invsmileface", "blacksmiley", "&#x263b;"]],
          omml: ["&#x263b;"],
          html: ["&#x263b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\invsmileface"
        end

        def to_asciimath(**)
          parsing_wrapper("blacksmiley", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263b;"
        end

        def to_html(**)
          "&#x263b;"
        end
      end
    end
  end
end
