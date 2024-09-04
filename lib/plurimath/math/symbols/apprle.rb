module Plurimath
  module Math
    module Symbols
      class Apprle < Symbol
        INPUT = {
          unicodemath: [["lesssim", "&#x2272;"], parsing_wrapper(["apprle"], lang: :unicode)],
          asciimath: [["&#x2272;"], parsing_wrapper(["lesssim", "apprle"], lang: :asciimath)],
          mathml: ["&#x2272;"],
          latex: [["lesssim", "apprle", "&#x2272;"]],
          omml: ["&#x2272;"],
          html: ["&#x2272;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesssim"
        end

        def to_asciimath(**)
          parsing_wrapper("apprle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2272;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2272;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2272;"
        end

        def to_html(**)
          "&#x2272;"
        end
      end
    end
  end
end
