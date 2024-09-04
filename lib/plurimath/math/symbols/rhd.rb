module Plurimath
  module Math
    module Symbols
      class Rhd < Symbol
        INPUT = {
          unicodemath: [["&#x25b7;"], parsing_wrapper(["triangleright", "rres", "rhd"], lang: :unicode)],
          asciimath: [["&#x25b7;"], parsing_wrapper(["triangleright", "rres", "rhd"], lang: :asciimath)],
          mathml: ["&#x25b7;"],
          latex: [["triangleright", "rres", "rhd", "&#x25b7;"]],
          omml: ["&#x25b7;"],
          html: ["&#x25b7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleright"
        end

        def to_asciimath(**)
          parsing_wrapper("rhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b7;"
        end

        def to_html(**)
          "&#x25b7;"
        end
      end
    end
  end
end
