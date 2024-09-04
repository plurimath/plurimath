module Plurimath
  module Math
    module Symbols
      class Wideangledown < Symbol
        INPUT = {
          unicodemath: [["&#x29a6;"], parsing_wrapper(["wideangledown"], lang: :unicode)],
          asciimath: [["&#x29a6;"], parsing_wrapper(["wideangledown"], lang: :asciimath)],
          mathml: ["&#x29a6;"],
          latex: [["wideangledown", "&#x29a6;"]],
          omml: ["&#x29a6;"],
          html: ["&#x29a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wideangledown"
        end

        def to_asciimath(**)
          parsing_wrapper("wideangledown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a6;"
        end

        def to_html(**)
          "&#x29a6;"
        end
      end
    end
  end
end
