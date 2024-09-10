module Plurimath
  module Math
    module Symbols
      class Ularc < Symbol
        INPUT = {
          unicodemath: [["&#x25dc;"], parsing_wrapper(["ularc"], lang: :unicode)],
          asciimath: [["&#x25dc;"], parsing_wrapper(["ularc"], lang: :asciimath)],
          mathml: ["&#x25dc;"],
          latex: [["ularc", "&#x25dc;"]],
          omml: ["&#x25dc;"],
          html: ["&#x25dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ularc"
        end

        def to_asciimath(**)
          parsing_wrapper("ularc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25dc;"
        end

        def to_html(**)
          "&#x25dc;"
        end
      end
    end
  end
end
