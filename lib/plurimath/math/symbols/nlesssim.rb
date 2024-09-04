module Plurimath
  module Math
    module Symbols
      class Nlesssim < Symbol
        INPUT = {
          unicodemath: [["&#x2274;"], parsing_wrapper(["NotLessTilde", "nlesssim"], lang: :unicode)],
          asciimath: [["&#x2274;"], parsing_wrapper(["NotLessTilde", "nlesssim"], lang: :asciimath)],
          mathml: ["&#x2274;"],
          latex: [["NotLessTilde", "nlesssim", "&#x2274;"]],
          omml: ["&#x2274;"],
          html: ["&#x2274;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\NotLessTilde"
        end

        def to_asciimath(**)
          parsing_wrapper("nlesssim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2274;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2274;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2274;"
        end

        def to_html(**)
          "&#x2274;"
        end
      end
    end
  end
end
