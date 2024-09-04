module Plurimath
  module Math
    module Symbols
      class Lbrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x27ec;"], parsing_wrapper(["Lbrbrak"], lang: :unicode)],
          asciimath: [["&#x27ec;"], parsing_wrapper(["Lbrbrak"], lang: :asciimath)],
          mathml: ["&#x27ec;"],
          latex: [["Lbrbrak", "&#x27ec;"]],
          omml: ["&#x27ec;"],
          html: ["&#x27ec;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Lbrbrak"
        end

        def to_asciimath(**)
          parsing_wrapper("Lbrbrak", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27ec;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27ec;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27ec;"
        end

        def to_html(**)
          "&#x27ec;"
        end
      end
    end
  end
end
