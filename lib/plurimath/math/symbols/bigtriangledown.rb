module Plurimath
  module Math
    module Symbols
      class Bigtriangledown < Symbol
        INPUT = {
          unicodemath: [["&#x25bd;"], parsing_wrapper(["bigtriangledown"], lang: :unicode)],
          asciimath: [["&#x25bd;"], parsing_wrapper(["bigtriangledown"], lang: :asciimath)],
          mathml: ["&#x25bd;"],
          latex: [["bigtriangledown", "&#x25bd;"]],
          omml: ["&#x25bd;"],
          html: ["&#x25bd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigtriangledown"
        end

        def to_asciimath(**)
          parsing_wrapper("bigtriangledown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25bd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25bd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25bd;"
        end

        def to_html(**)
          "&#x25bd;"
        end
      end
    end
  end
end
