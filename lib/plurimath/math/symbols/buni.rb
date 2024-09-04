module Plurimath
  module Math
    module Symbols
      class Buni < Symbol
        INPUT = {
          unicodemath: [["uplus", "&#x228e;"], parsing_wrapper(["buni"], lang: :unicode)],
          asciimath: [["&#x228e;"], parsing_wrapper(["uplus", "buni"], lang: :asciimath)],
          mathml: ["&#x228e;"],
          latex: [["uplus", "buni", "&#x228e;"]],
          omml: ["&#x228e;"],
          html: ["&#x228e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uplus"
        end

        def to_asciimath(**)
          parsing_wrapper("buni", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x228e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x228e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x228e;"
        end

        def to_html(**)
          "&#x228e;"
        end
      end
    end
  end
end
