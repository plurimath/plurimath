module Plurimath
  module Math
    module Symbols
      class Leftupteevector < Symbol
        INPUT = {
          unicodemath: [["&#x2960;"], parsing_wrapper(["upharpoonleftbar", "LeftUpTeeVector"], lang: :unicode)],
          asciimath: [["&#x2960;"], parsing_wrapper(["upharpoonleftbar", "LeftUpTeeVector"], lang: :asciimath)],
          mathml: ["&#x2960;"],
          latex: [["upharpoonleftbar", "LeftUpTeeVector", "&#x2960;"]],
          omml: ["&#x2960;"],
          html: ["&#x2960;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upharpoonleftbar"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftUpTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2960;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2960;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2960;"
        end

        def to_html(**)
          "&#x2960;"
        end
      end
    end
  end
end
