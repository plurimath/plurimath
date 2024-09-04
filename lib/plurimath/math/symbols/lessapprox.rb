module Plurimath
  module Math
    module Symbols
      class Lessapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2a85;"], parsing_wrapper(["lessapprox"], lang: :unicode)],
          asciimath: [["&#x2a85;"], parsing_wrapper(["lessapprox"], lang: :asciimath)],
          mathml: ["&#x2a85;"],
          latex: [["lessapprox", "&#x2a85;"]],
          omml: ["&#x2a85;"],
          html: ["&#x2a85;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lessapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("lessapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a85;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a85;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a85;"
        end

        def to_html(**)
          "&#x2a85;"
        end
      end
    end
  end
end
