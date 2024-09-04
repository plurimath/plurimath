module Plurimath
  module Math
    module Symbols
      class Leftmoon < Symbol
        INPUT = {
          unicodemath: [["&#x263e;"], parsing_wrapper(["leftmoon"], lang: :unicode)],
          asciimath: [["&#x263e;"], parsing_wrapper(["leftmoon"], lang: :asciimath)],
          mathml: ["&#x263e;"],
          latex: [["leftmoon", "&#x263e;"]],
          omml: ["&#x263e;"],
          html: ["&#x263e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftmoon"
        end

        def to_asciimath(**)
          parsing_wrapper("leftmoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263e;"
        end

        def to_html(**)
          "&#x263e;"
        end
      end
    end
  end
end
