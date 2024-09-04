module Plurimath
  module Math
    module Symbols
      class Ccwundercurvearrow < Symbol
        INPUT = {
          unicodemath: [["&#x293f;"], parsing_wrapper(["ccwundercurvearrow"], lang: :unicode)],
          asciimath: [["&#x293f;"], parsing_wrapper(["ccwundercurvearrow"], lang: :asciimath)],
          mathml: ["&#x293f;"],
          latex: [["ccwundercurvearrow", "&#x293f;"]],
          omml: ["&#x293f;"],
          html: ["&#x293f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ccwundercurvearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("ccwundercurvearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293f;"
        end

        def to_html(**)
          "&#x293f;"
        end
      end
    end
  end
end
