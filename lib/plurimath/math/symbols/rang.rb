module Plurimath
  module Math
    module Symbols
      class Rang < Symbol
        INPUT = {
          unicodemath: [["&#x27eb;"], parsing_wrapper(["rAngle", "rang"], lang: :unicode)],
          asciimath: [["&#x27eb;"], parsing_wrapper(["rAngle", "rang"], lang: :asciimath)],
          mathml: ["&#x27eb;"],
          latex: [["rAngle", "rang", "&#x27eb;"]],
          omml: ["&#x27eb;"],
          html: ["&#x27eb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rAngle"
        end

        def to_asciimath(**)
          parsing_wrapper("rang", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27eb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27eb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27eb;"
        end

        def to_html(**)
          "&#x27eb;"
        end
      end
    end
  end
end
