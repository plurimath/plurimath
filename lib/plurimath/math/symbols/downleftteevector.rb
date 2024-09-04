module Plurimath
  module Math
    module Symbols
      class Downleftteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295e;"], parsing_wrapper(["leftharpoondownbar", "DownLeftTeeVector"], lang: :unicode)],
          asciimath: [["&#x295e;"], parsing_wrapper(["leftharpoondownbar", "DownLeftTeeVector"], lang: :asciimath)],
          mathml: ["&#x295e;"],
          latex: [["leftharpoondownbar", "DownLeftTeeVector", "&#x295e;"]],
          omml: ["&#x295e;"],
          html: ["&#x295e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftharpoondownbar"
        end

        def to_asciimath(**)
          parsing_wrapper("DownLeftTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x295e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x295e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x295e;"
        end

        def to_html(**)
          "&#x295e;"
        end
      end
    end
  end
end
