module Plurimath
  module Math
    module Symbols
      class Towa < Symbol
        INPUT = {
          unicodemath: [["&#x292a;"], parsing_wrapper(["towa"], lang: :unicode)],
          asciimath: [["&#x292a;"], parsing_wrapper(["towa"], lang: :asciimath)],
          mathml: ["&#x292a;"],
          latex: [["towa", "&#x292a;"]],
          omml: ["&#x292a;"],
          html: ["&#x292a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\towa"
        end

        def to_asciimath(**)
          parsing_wrapper("towa", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x292a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x292a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x292a;"
        end

        def to_html(**)
          "&#x292a;"
        end
      end
    end
  end
end
