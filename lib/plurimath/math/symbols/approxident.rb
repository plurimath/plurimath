module Plurimath
  module Math
    module Symbols
      class Approxident < Symbol
        INPUT = {
          unicodemath: [["&#x224b;"], parsing_wrapper(["approxident"], lang: :unicode)],
          asciimath: [["&#x224b;"], parsing_wrapper(["approxident"], lang: :asciimath)],
          mathml: ["&#x224b;"],
          latex: [["approxident", "&#x224b;"]],
          omml: ["&#x224b;"],
          html: ["&#x224b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\approxident"
        end

        def to_asciimath(**)
          parsing_wrapper("approxident", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x224b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x224b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x224b;"
        end

        def to_html(**)
          "&#x224b;"
        end
      end
    end
  end
end
