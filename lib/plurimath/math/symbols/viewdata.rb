module Plurimath
  module Math
    module Symbols
      class Viewdata < Symbol
        INPUT = {
          unicodemath: [["&#x2317;"], parsing_wrapper(["viewdata"], lang: :unicode)],
          asciimath: [["&#x2317;"], parsing_wrapper(["viewdata"], lang: :asciimath)],
          mathml: ["&#x2317;"],
          latex: [["viewdata", "&#x2317;"]],
          omml: ["&#x2317;"],
          html: ["&#x2317;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\viewdata"
        end

        def to_asciimath(**)
          parsing_wrapper("viewdata", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2317;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2317;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2317;"
        end

        def to_html(**)
          "&#x2317;"
        end
      end
    end
  end
end
