module Plurimath
  module Math
    module Symbols
      class Pitchfork < Symbol
        INPUT = {
          unicodemath: [["pitchfork", "&#x22d4;"]],
          asciimath: [["&#x22d4;"], parsing_wrapper(["pitchfork"], lang: :asciimath)],
          mathml: ["&#x22d4;"],
          latex: [["pitchfork", "&#x22d4;"]],
          omml: ["&#x22d4;"],
          html: ["&#x22d4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pitchfork"
        end

        def to_asciimath(**)
          parsing_wrapper("pitchfork", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d4;"
        end

        def to_html(**)
          "&#x22d4;"
        end
      end
    end
  end
end
