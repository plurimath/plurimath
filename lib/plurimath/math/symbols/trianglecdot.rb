module Plurimath
  module Math
    module Symbols
      class Trianglecdot < Symbol
        INPUT = {
          unicodemath: [["&#x25ec;"], parsing_wrapper(["trianglecdot"], lang: :unicode)],
          asciimath: [["&#x25ec;"], parsing_wrapper(["trianglecdot"], lang: :asciimath)],
          mathml: ["&#x25ec;"],
          latex: [["trianglecdot", "&#x25ec;"]],
          omml: ["&#x25ec;"],
          html: ["&#x25ec;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trianglecdot"
        end

        def to_asciimath(**)
          parsing_wrapper("trianglecdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ec;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ec;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ec;"
        end

        def to_html(**)
          "&#x25ec;"
        end
      end
    end
  end
end
