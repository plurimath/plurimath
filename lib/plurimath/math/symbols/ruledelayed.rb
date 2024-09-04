module Plurimath
  module Math
    module Symbols
      class Ruledelayed < Symbol
        INPUT = {
          unicodemath: [["&#x29f4;"], parsing_wrapper(["ruledelayed"], lang: :unicode)],
          asciimath: [["&#x29f4;"], parsing_wrapper(["ruledelayed"], lang: :asciimath)],
          mathml: ["&#x29f4;"],
          latex: [["ruledelayed", "&#x29f4;"]],
          omml: ["&#x29f4;"],
          html: ["&#x29f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ruledelayed"
        end

        def to_asciimath(**)
          parsing_wrapper("ruledelayed", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f4;"
        end

        def to_html(**)
          "&#x29f4;"
        end
      end
    end
  end
end
