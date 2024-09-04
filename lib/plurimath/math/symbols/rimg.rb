module Plurimath
  module Math
    module Symbols
      class Rimg < Symbol
        INPUT = {
          unicodemath: [["&#x2988;"], parsing_wrapper(["rrparenthesis", "rimg"], lang: :unicode)],
          asciimath: [["&#x2988;"], parsing_wrapper(["rrparenthesis", "rimg"], lang: :asciimath)],
          mathml: ["&#x2988;"],
          latex: [["rrparenthesis", "rimg", "&#x2988;"]],
          omml: ["&#x2988;"],
          html: ["&#x2988;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rrparenthesis"
        end

        def to_asciimath(**)
          parsing_wrapper("rimg", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2988;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2988;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2988;"
        end

        def to_html(**)
          "&#x2988;"
        end
      end
    end
  end
end
