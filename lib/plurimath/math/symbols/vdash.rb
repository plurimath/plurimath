module Plurimath
  module Math
    module Symbols
      class Vdash < Symbol
        INPUT = {
          unicodemath: [["vdash", "&#x22a2;"], parsing_wrapper(["|--"], lang: :unicode)],
          asciimath: [["vdash", "|--", "&#x22a2;"]],
          mathml: ["&#x22a2;"],
          latex: [["vdash", "&#x22a2;"], parsing_wrapper(["|--"], lang: :latex)],
          omml: ["&#x22a2;"],
          html: ["&#x22a2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vdash"
        end

        def to_asciimath(**)
          "vdash"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a2;"
        end

        def to_html(**)
          "&#x22a2;"
        end
      end
    end
  end
end
