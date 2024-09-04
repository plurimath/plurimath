module Plurimath
  module Math
    module Symbols
      class Intprodr < Symbol
        INPUT = {
          unicodemath: [["&#x2a3d;"], parsing_wrapper(["intprodr"], lang: :unicode)],
          asciimath: [["&#x2a3d;"], parsing_wrapper(["intprodr"], lang: :asciimath)],
          mathml: ["&#x2a3d;"],
          latex: [["intprodr", "&#x2a3d;"]],
          omml: ["&#x2a3d;"],
          html: ["&#x2a3d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intprodr"
        end

        def to_asciimath(**)
          parsing_wrapper("intprodr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3d;"
        end

        def to_html(**)
          "&#x2a3d;"
        end
      end
    end
  end
end
