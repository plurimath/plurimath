module Plurimath
  module Math
    module Symbols
      class Hbar < Symbol
        INPUT = {
          unicodemath: [["hbar", "&#x210f;"], parsing_wrapper(["hslash"], lang: :unicode)],
          asciimath: [["&#x210f;"], parsing_wrapper(["hbar", "hslash"], lang: :asciimath)],
          mathml: ["&#x210f;"],
          latex: [["hslash", "&#x210f;"], parsing_wrapper(["hbar"], lang: :latex)],
          omml: ["&#x210f;"],
          html: ["&#x210f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hslash"
        end

        def to_asciimath(**)
          parsing_wrapper("hbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x210f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x210f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x210f;"
        end

        def to_html(**)
          "&#x210f;"
        end
      end
    end
  end
end
