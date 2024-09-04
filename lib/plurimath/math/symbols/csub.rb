module Plurimath
  module Math
    module Symbols
      class Csub < Symbol
        INPUT = {
          unicodemath: [["&#x2acf;"], parsing_wrapper(["csub"], lang: :unicode)],
          asciimath: [["&#x2acf;"], parsing_wrapper(["csub"], lang: :asciimath)],
          mathml: ["&#x2acf;"],
          latex: [["csub", "&#x2acf;"]],
          omml: ["&#x2acf;"],
          html: ["&#x2acf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\csub"
        end

        def to_asciimath(**)
          parsing_wrapper("csub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2acf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2acf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2acf;"
        end

        def to_html(**)
          "&#x2acf;"
        end
      end
    end
  end
end
