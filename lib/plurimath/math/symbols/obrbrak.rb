module Plurimath
  module Math
    module Symbols
      class Obrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x23e0;"], parsing_wrapper(["obrbrak"], lang: :unicode)],
          asciimath: [["&#x23e0;"], parsing_wrapper(["obrbrak"], lang: :asciimath)],
          mathml: ["&#x23e0;"],
          latex: [["obrbrak", "&#x23e0;"]],
          omml: ["&#x23e0;"],
          html: ["&#x23e0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\obrbrak"
        end

        def to_asciimath(**)
          parsing_wrapper("obrbrak", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e0;"
        end

        def to_html(**)
          "&#x23e0;"
        end
      end
    end
  end
end
