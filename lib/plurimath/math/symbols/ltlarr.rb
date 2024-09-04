module Plurimath
  module Math
    module Symbols
      class Ltlarr < Symbol
        INPUT = {
          unicodemath: [["&#x2976;"], parsing_wrapper(["ltlarr"], lang: :unicode)],
          asciimath: [["&#x2976;"], parsing_wrapper(["ltlarr"], lang: :asciimath)],
          mathml: ["&#x2976;"],
          latex: [["ltlarr", "&#x2976;"]],
          omml: ["&#x2976;"],
          html: ["&#x2976;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ltlarr"
        end

        def to_asciimath(**)
          parsing_wrapper("ltlarr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2976;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2976;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2976;"
        end

        def to_html(**)
          "&#x2976;"
        end
      end
    end
  end
end
