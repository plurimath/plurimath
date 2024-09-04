module Plurimath
  module Math
    module Symbols
      class Scurel < Symbol
        INPUT = {
          unicodemath: [["&#x22b1;"], parsing_wrapper(["scurel"], lang: :unicode)],
          asciimath: [["&#x22b1;"], parsing_wrapper(["scurel"], lang: :asciimath)],
          mathml: ["&#x22b1;"],
          latex: [["scurel", "&#x22b1;"]],
          omml: ["&#x22b1;"],
          html: ["&#x22b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\scurel"
        end

        def to_asciimath(**)
          parsing_wrapper("scurel", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b1;"
        end

        def to_html(**)
          "&#x22b1;"
        end
      end
    end
  end
end
