module Plurimath
  module Math
    module Symbols
      class Nwovnearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2932;"], parsing_wrapper(["nwovnearrow"], lang: :unicode)],
          asciimath: [["&#x2932;"], parsing_wrapper(["nwovnearrow"], lang: :asciimath)],
          mathml: ["&#x2932;"],
          latex: [["nwovnearrow", "&#x2932;"]],
          omml: ["&#x2932;"],
          html: ["&#x2932;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nwovnearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nwovnearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2932;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2932;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2932;"
        end

        def to_html(**)
          "&#x2932;"
        end
      end
    end
  end
end
