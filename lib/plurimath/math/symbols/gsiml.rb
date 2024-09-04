module Plurimath
  module Math
    module Symbols
      class Gsiml < Symbol
        INPUT = {
          unicodemath: [["&#x2a90;"], parsing_wrapper(["gsiml"], lang: :unicode)],
          asciimath: [["&#x2a90;"], parsing_wrapper(["gsiml"], lang: :asciimath)],
          mathml: ["&#x2a90;"],
          latex: [["gsiml", "&#x2a90;"]],
          omml: ["&#x2a90;"],
          html: ["&#x2a90;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gsiml"
        end

        def to_asciimath(**)
          parsing_wrapper("gsiml", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a90;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a90;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a90;"
        end

        def to_html(**)
          "&#x2a90;"
        end
      end
    end
  end
end
