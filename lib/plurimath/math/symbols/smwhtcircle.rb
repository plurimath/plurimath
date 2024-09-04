module Plurimath
  module Math
    module Symbols
      class Smwhtcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25e6;"], parsing_wrapper(["smwhtcircle"], lang: :unicode)],
          asciimath: [["&#x25e6;"], parsing_wrapper(["smwhtcircle"], lang: :asciimath)],
          mathml: ["&#x25e6;"],
          latex: [["smwhtcircle", "&#x25e6;"]],
          omml: ["&#x25e6;"],
          html: ["&#x25e6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smwhtcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("smwhtcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e6;"
        end

        def to_html(**)
          "&#x25e6;"
        end
      end
    end
  end
end
