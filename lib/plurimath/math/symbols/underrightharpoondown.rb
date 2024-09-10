module Plurimath
  module Math
    module Symbols
      class Underrightharpoondown < Symbol
        INPUT = {
          unicodemath: [["&#x20ec;"], parsing_wrapper(["underrightharpoondown"], lang: :unicode)],
          asciimath: [["&#x20ec;"], parsing_wrapper(["underrightharpoondown"], lang: :asciimath)],
          mathml: ["&#x20ec;"],
          latex: [["underrightharpoondown", "&#x20ec;"]],
          omml: ["&#x20ec;"],
          html: ["&#x20ec;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underrightharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("underrightharpoondown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20ec;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20ec;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20ec;"
        end

        def to_html(**)
          "&#x20ec;"
        end
      end
    end
  end
end
