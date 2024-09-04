module Plurimath
  module Math
    module Symbols
      class Curvearrowleftplus < Symbol
        INPUT = {
          unicodemath: [["&#x293d;"], parsing_wrapper(["curvearrowleftplus"], lang: :unicode)],
          asciimath: [["&#x293d;"], parsing_wrapper(["curvearrowleftplus"], lang: :asciimath)],
          mathml: ["&#x293d;"],
          latex: [["curvearrowleftplus", "&#x293d;"]],
          omml: ["&#x293d;"],
          html: ["&#x293d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curvearrowleftplus"
        end

        def to_asciimath(**)
          parsing_wrapper("curvearrowleftplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293d;"
        end

        def to_html(**)
          "&#x293d;"
        end
      end
    end
  end
end
