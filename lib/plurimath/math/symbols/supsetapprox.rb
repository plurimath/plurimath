module Plurimath
  module Math
    module Symbols
      class Supsetapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2aca;"], parsing_wrapper(["supsetapprox"], lang: :unicode)],
          asciimath: [["&#x2aca;"], parsing_wrapper(["supsetapprox"], lang: :asciimath)],
          mathml: ["&#x2aca;"],
          latex: [["supsetapprox", "&#x2aca;"]],
          omml: ["&#x2aca;"],
          html: ["&#x2aca;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsetapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("supsetapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aca;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aca;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aca;"
        end

        def to_html(**)
          "&#x2aca;"
        end
      end
    end
  end
end
