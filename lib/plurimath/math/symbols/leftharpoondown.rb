module Plurimath
  module Math
    module Symbols
      class Leftharpoondown < Symbol
        INPUT = {
          unicodemath: [["leftharpoondown", "&#x21bd;"]],
          asciimath: [["&#x21bd;"], parsing_wrapper(["leftharpoondown"], lang: :asciimath)],
          mathml: ["&#x21bd;"],
          latex: [["leftharpoondown", "&#x21bd;"]],
          omml: ["&#x21bd;"],
          html: ["&#x21bd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("leftharpoondown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21bd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21bd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21bd;"
        end

        def to_html(**)
          "&#x21bd;"
        end
      end
    end
  end
end
