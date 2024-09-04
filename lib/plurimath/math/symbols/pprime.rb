module Plurimath
  module Math
    module Symbols
      class Pprime < Symbol
        INPUT = {
          unicodemath: [["pprime", "&#x2033;"], parsing_wrapper(["''", "second", "dprime"], lang: :unicode)],
          asciimath: [["''", "&#x2033;"], parsing_wrapper(["pprime", "second", "dprime"], lang: :asciimath)],
          mathml: ["&#x2033;"],
          latex: [["second", "dprime", "&#x2033;"], parsing_wrapper(["pprime", "''"], lang: :latex)],
          omml: ["&#x2033;"],
          html: ["&#x2033;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\second"
        end

        def to_asciimath(**)
          parsing_wrapper("pprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2033;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2033;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2033;"
        end

        def to_html(**)
          "&#x2033;"
        end
      end
    end
  end
end
