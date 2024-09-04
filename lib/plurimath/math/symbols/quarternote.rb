module Plurimath
  module Math
    module Symbols
      class Quarternote < Symbol
        INPUT = {
          unicodemath: [["&#x2669;"], parsing_wrapper(["quarternote"], lang: :unicode)],
          asciimath: [["&#x2669;"], parsing_wrapper(["quarternote"], lang: :asciimath)],
          mathml: ["&#x2669;"],
          latex: [["quarternote", "&#x2669;"]],
          omml: ["&#x2669;"],
          html: ["&#x2669;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\quarternote"
        end

        def to_asciimath(**)
          parsing_wrapper("quarternote", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2669;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2669;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2669;"
        end

        def to_html(**)
          "&#x2669;"
        end
      end
    end
  end
end
