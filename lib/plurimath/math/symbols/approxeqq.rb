module Plurimath
  module Math
    module Symbols
      class Approxeqq < Symbol
        INPUT = {
          unicodemath: [["&#x2a70;"], parsing_wrapper(["approxeqq"], lang: :unicode)],
          asciimath: [["&#x2a70;"], parsing_wrapper(["approxeqq"], lang: :asciimath)],
          mathml: ["&#x2a70;"],
          latex: [["approxeqq", "&#x2a70;"]],
          omml: ["&#x2a70;"],
          html: ["&#x2a70;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\approxeqq"
        end

        def to_asciimath(**)
          parsing_wrapper("approxeqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a70;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a70;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a70;"
        end

        def to_html(**)
          "&#x2a70;"
        end
      end
    end
  end
end
