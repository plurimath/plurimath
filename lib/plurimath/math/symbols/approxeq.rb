module Plurimath
  module Math
    module Symbols
      class Approxeq < Symbol
        INPUT = {
          unicodemath: [["approxeq", "&#x224a;"]],
          asciimath: [["&#x224a;"], parsing_wrapper(["approxeq"])],
          mathml: ["&#x224a;"],
          latex: [["approxeq", "&#x224a;"]],
          omml: ["&#x224a;"],
          html: ["&#x224a;"],
        }.freeze

        # output methods
        def to_latex
          "\\approxeq"
        end

        def to_asciimath
          parsing_wrapper("approxeq")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x224a;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x224a;"
        end

        def to_omml_without_math_tag(_)
          "&#x224a;"
        end

        def to_html
          "&#x224a;"
        end
      end
    end
  end
end
