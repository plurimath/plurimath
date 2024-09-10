module Plurimath
  module Math
    module Symbols
      class Triangleubar < Symbol
        INPUT = {
          unicodemath: [["&#x29cb;"], parsing_wrapper(["triangleubar"], lang: :unicode)],
          asciimath: [["&#x29cb;"], parsing_wrapper(["triangleubar"], lang: :asciimath)],
          mathml: ["&#x29cb;"],
          latex: [["triangleubar", "&#x29cb;"]],
          omml: ["&#x29cb;"],
          html: ["&#x29cb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleubar"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleubar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29cb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29cb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29cb;"
        end

        def to_html(**)
          "&#x29cb;"
        end
      end
    end
  end
end
