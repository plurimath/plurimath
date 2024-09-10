module Plurimath
  module Math
    module Symbols
      class Underleftharpoondown < Symbol
        INPUT = {
          unicodemath: [["&#x20ed;"], parsing_wrapper(["underleftharpoondown"], lang: :unicode)],
          asciimath: [["&#x20ed;"], parsing_wrapper(["underleftharpoondown"], lang: :asciimath)],
          mathml: ["&#x20ed;"],
          latex: [["underleftharpoondown", "&#x20ed;"]],
          omml: ["&#x20ed;"],
          html: ["&#x20ed;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underleftharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("underleftharpoondown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20ed;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20ed;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20ed;"
        end

        def to_html(**)
          "&#x20ed;"
        end
      end
    end
  end
end
