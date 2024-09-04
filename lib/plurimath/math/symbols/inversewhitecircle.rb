module Plurimath
  module Math
    module Symbols
      class Inversewhitecircle < Symbol
        INPUT = {
          unicodemath: [["&#x25d9;"], parsing_wrapper(["inversewhitecircle"], lang: :unicode)],
          asciimath: [["&#x25d9;"], parsing_wrapper(["inversewhitecircle"], lang: :asciimath)],
          mathml: ["&#x25d9;"],
          latex: [["inversewhitecircle", "&#x25d9;"]],
          omml: ["&#x25d9;"],
          html: ["&#x25d9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\inversewhitecircle"
        end

        def to_asciimath(**)
          parsing_wrapper("inversewhitecircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d9;"
        end

        def to_html(**)
          "&#x25d9;"
        end
      end
    end
  end
end
