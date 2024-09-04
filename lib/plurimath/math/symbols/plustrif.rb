module Plurimath
  module Math
    module Symbols
      class Plustrif < Symbol
        INPUT = {
          unicodemath: [["&#x2a28;"], parsing_wrapper(["plustrif"], lang: :unicode)],
          asciimath: [["&#x2a28;"], parsing_wrapper(["plustrif"], lang: :asciimath)],
          mathml: ["&#x2a28;"],
          latex: [["plustrif", "&#x2a28;"]],
          omml: ["&#x2a28;"],
          html: ["&#x2a28;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\plustrif"
        end

        def to_asciimath(**)
          parsing_wrapper("plustrif", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a28;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a28;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a28;"
        end

        def to_html(**)
          "&#x2a28;"
        end
      end
    end
  end
end
