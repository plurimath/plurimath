module Plurimath
  module Math
    module Symbols
      class Lhd < Symbol
        INPUT = {
          unicodemath: [["&#x25c1;"], parsing_wrapper(["triangleleft", "dres", "lhd"], lang: :unicode)],
          asciimath: [["&#x25c1;"], parsing_wrapper(["triangleleft", "dres", "lhd"], lang: :asciimath)],
          mathml: ["&#x25c1;"],
          latex: [["triangleleft", "dres", "lhd", "&#x25c1;"]],
          omml: ["&#x25c1;"],
          html: ["&#x25c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleleft"
        end

        def to_asciimath(**)
          parsing_wrapper("lhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c1;"
        end

        def to_html(**)
          "&#x25c1;"
        end
      end
    end
  end
end
