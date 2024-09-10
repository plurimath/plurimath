module Plurimath
  module Math
    module Symbols
      class Triangleserifs < Symbol
        INPUT = {
          unicodemath: [["&#x29cd;"], parsing_wrapper(["triangleserifs"], lang: :unicode)],
          asciimath: [["&#x29cd;"], parsing_wrapper(["triangleserifs"], lang: :asciimath)],
          mathml: ["&#x29cd;"],
          latex: [["triangleserifs", "&#x29cd;"]],
          omml: ["&#x29cd;"],
          html: ["&#x29cd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleserifs"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleserifs", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29cd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29cd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29cd;"
        end

        def to_html(**)
          "&#x29cd;"
        end
      end
    end
  end
end
