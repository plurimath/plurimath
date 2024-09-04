module Plurimath
  module Math
    module Symbols
      class Wideangleup < Symbol
        INPUT = {
          unicodemath: [["&#x29a7;"], parsing_wrapper(["wideangleup"], lang: :unicode)],
          asciimath: [["&#x29a7;"], parsing_wrapper(["wideangleup"], lang: :asciimath)],
          mathml: ["&#x29a7;"],
          latex: [["wideangleup", "&#x29a7;"]],
          omml: ["&#x29a7;"],
          html: ["&#x29a7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wideangleup"
        end

        def to_asciimath(**)
          parsing_wrapper("wideangleup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a7;"
        end

        def to_html(**)
          "&#x29a7;"
        end
      end
    end
  end
end
