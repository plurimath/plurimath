module Plurimath
  module Math
    module Symbols
      class Complement < Symbol
        INPUT = {
          unicodemath: [["complement", "&#x2201;"]],
          asciimath: [["&#x2201;"], parsing_wrapper(["complement"], lang: :asciimath)],
          mathml: ["&#x2201;"],
          latex: [["complement", "&#x2201;"]],
          omml: ["&#x2201;"],
          html: ["&#x2201;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\complement"
        end

        def to_asciimath(**)
          parsing_wrapper("complement", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2201;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2201;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2201;"
        end

        def to_html(**)
          "&#x2201;"
        end
      end
    end
  end
end
