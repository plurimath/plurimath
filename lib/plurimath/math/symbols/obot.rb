module Plurimath
  module Math
    module Symbols
      class Obot < Symbol
        INPUT = {
          unicodemath: [["&#x29ba;"], parsing_wrapper(["obot"], lang: :unicode)],
          asciimath: [["&#x29ba;"], parsing_wrapper(["obot"], lang: :asciimath)],
          mathml: ["&#x29ba;"],
          latex: [["obot", "&#x29ba;"]],
          omml: ["&#x29ba;"],
          html: ["&#x29ba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\obot"
        end

        def to_asciimath(**)
          parsing_wrapper("obot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ba;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ba;"
        end

        def to_html(**)
          "&#x29ba;"
        end
      end
    end
  end
end
