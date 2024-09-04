module Plurimath
  module Math
    module Symbols
      class Longmapsto < Symbol
        INPUT = {
          unicodemath: [["&#x27fe;"], parsing_wrapper(["Longmapsto"], lang: :unicode)],
          asciimath: [["&#x27fe;"], parsing_wrapper(["Longmapsto"], lang: :asciimath)],
          mathml: ["&#x27fe;"],
          latex: [["Longmapsto", "&#x27fe;"]],
          omml: ["&#x27fe;"],
          html: ["&#x27fe;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Longmapsto"
        end

        def to_asciimath(**)
          parsing_wrapper("Longmapsto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27fe;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27fe;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27fe;"
        end

        def to_html(**)
          "&#x27fe;"
        end
      end
    end
  end
end
