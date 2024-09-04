module Plurimath
  module Math
    module Symbols
      class Ring < Symbol
        INPUT = {
          unicodemath: [["&#x30a;"], parsing_wrapper(["mathring", "ocirc", "ring"], lang: :unicode)],
          asciimath: [["&#x30a;"], parsing_wrapper(["mathring", "ocirc", "ring"], lang: :asciimath)],
          mathml: ["&#x30a;"],
          latex: [["mathring", "ocirc", "ring", "&#x30a;"]],
          omml: ["&#x30a;"],
          html: ["&#x30a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathring"
        end

        def to_asciimath(**)
          parsing_wrapper("ring", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x30a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x30a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x30a;"
        end

        def to_html(**)
          "&#x30a;"
        end
      end
    end
  end
end
