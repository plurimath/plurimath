module Plurimath
  module Math
    module Symbols
      class Lang < Symbol
        INPUT = {
          unicodemath: [["&#x27ea;"], parsing_wrapper(["lAngle", "lang"], lang: :unicode)],
          asciimath: [["&#x27ea;"], parsing_wrapper(["lAngle", "lang"], lang: :asciimath)],
          mathml: ["&#x27ea;"],
          latex: [["lAngle", "lang", "&#x27ea;"]],
          omml: ["&#x27ea;"],
          html: ["&#x27ea;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lang"
        end

        def to_asciimath(**)
          "lang"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27ea;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27ea;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27ea;"
        end

        def to_html(**)
          "&#x27ea;"
        end
      end
    end
  end
end
