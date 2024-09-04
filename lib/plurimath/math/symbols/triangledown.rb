module Plurimath
  module Math
    module Symbols
      class Triangledown < Symbol
        INPUT = {
          unicodemath: [["&#x25bf;"], parsing_wrapper(["smalltriangledown", "triangledown"], lang: :unicode)],
          asciimath: [["&#x25bf;"], parsing_wrapper(["smalltriangledown", "triangledown"], lang: :asciimath)],
          mathml: ["&#x25bf;"],
          latex: [["smalltriangledown", "triangledown", "&#x25bf;"]],
          omml: ["&#x25bf;"],
          html: ["&#x25bf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smalltriangledown"
        end

        def to_asciimath(**)
          parsing_wrapper("triangledown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25bf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25bf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25bf;"
        end

        def to_html(**)
          "&#x25bf;"
        end
      end
    end
  end
end
