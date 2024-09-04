module Plurimath
  module Math
    module Symbols
      class Perps < Symbol
        INPUT = {
          unicodemath: [["&#x2ae1;"], parsing_wrapper(["perps"], lang: :unicode)],
          asciimath: [["&#x2ae1;"], parsing_wrapper(["perps"], lang: :asciimath)],
          mathml: ["&#x2ae1;"],
          latex: [["perps", "&#x2ae1;"]],
          omml: ["&#x2ae1;"],
          html: ["&#x2ae1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\perps"
        end

        def to_asciimath(**)
          parsing_wrapper("perps", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ae1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ae1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ae1;"
        end

        def to_html(**)
          "&#x2ae1;"
        end
      end
    end
  end
end
