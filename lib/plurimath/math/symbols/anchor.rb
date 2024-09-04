module Plurimath
  module Math
    module Symbols
      class Anchor < Symbol
        INPUT = {
          unicodemath: [["&#x2693;"], parsing_wrapper(["anchor"], lang: :unicode)],
          asciimath: [["&#x2693;"], parsing_wrapper(["anchor"], lang: :asciimath)],
          mathml: ["&#x2693;"],
          latex: [["anchor", "&#x2693;"]],
          omml: ["&#x2693;"],
          html: ["&#x2693;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\anchor"
        end

        def to_asciimath(**)
          parsing_wrapper("anchor", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2693;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2693;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2693;"
        end

        def to_html(**)
          "&#x2693;"
        end
      end
    end
  end
end
