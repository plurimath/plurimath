module Plurimath
  module Math
    module Symbols
      class Vertoverlay < Symbol
        INPUT = {
          unicodemath: [["&#x20d2;"], parsing_wrapper(["vertoverlay"], lang: :unicode)],
          asciimath: [["&#x20d2;"], parsing_wrapper(["vertoverlay"], lang: :asciimath)],
          mathml: ["&#x20d2;"],
          latex: [["vertoverlay", "&#x20d2;"]],
          omml: ["&#x20d2;"],
          html: ["&#x20d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vertoverlay"
        end

        def to_asciimath(**)
          parsing_wrapper("vertoverlay", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20d2;"
        end

        def to_html(**)
          "&#x20d2;"
        end
      end
    end
  end
end
