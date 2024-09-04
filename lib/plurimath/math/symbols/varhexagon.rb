module Plurimath
  module Math
    module Symbols
      class Varhexagon < Symbol
        INPUT = {
          unicodemath: [["&#x2b21;"], parsing_wrapper(["varhexagon"], lang: :unicode)],
          asciimath: [["&#x2b21;"], parsing_wrapper(["varhexagon"], lang: :asciimath)],
          mathml: ["&#x2b21;"],
          latex: [["varhexagon", "&#x2b21;"]],
          omml: ["&#x2b21;"],
          html: ["&#x2b21;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varhexagon"
        end

        def to_asciimath(**)
          parsing_wrapper("varhexagon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b21;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b21;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b21;"
        end

        def to_html(**)
          "&#x2b21;"
        end
      end
    end
  end
end
