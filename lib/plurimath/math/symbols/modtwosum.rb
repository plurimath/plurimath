module Plurimath
  module Math
    module Symbols
      class Modtwosum < Symbol
        INPUT = {
          unicodemath: [["&#x2a0a;"], parsing_wrapper(["modtwosum"], lang: :unicode)],
          asciimath: [["&#x2a0a;"], parsing_wrapper(["modtwosum"], lang: :asciimath)],
          mathml: ["&#x2a0a;"],
          latex: [["modtwosum", "&#x2a0a;"]],
          omml: ["&#x2a0a;"],
          html: ["&#x2a0a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\modtwosum"
        end

        def to_asciimath(**)
          parsing_wrapper("modtwosum", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a0a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a0a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a0a;"
        end

        def to_html(**)
          "&#x2a0a;"
        end
      end
    end
  end
end
