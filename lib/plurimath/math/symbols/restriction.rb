module Plurimath
  module Math
    module Symbols
      class Restriction < Symbol
        INPUT = {
          unicodemath: [["upharpoonright", "&#x21be;"], parsing_wrapper(["restriction"], lang: :unicode)],
          asciimath: [["&#x21be;"], parsing_wrapper(["upharpoonright", "restriction"], lang: :asciimath)],
          mathml: ["&#x21be;"],
          latex: [["upharpoonright", "restriction", "&#x21be;"]],
          omml: ["&#x21be;"],
          html: ["&#x21be;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upharpoonright"
        end

        def to_asciimath(**)
          parsing_wrapper("restriction", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21be;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21be;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21be;"
        end

        def to_html(**)
          "&#x21be;"
        end
      end
    end
  end
end
