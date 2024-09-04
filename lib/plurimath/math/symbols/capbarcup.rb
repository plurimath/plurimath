module Plurimath
  module Math
    module Symbols
      class Capbarcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a49;"], parsing_wrapper(["capbarcup"], lang: :unicode)],
          asciimath: [["&#x2a49;"], parsing_wrapper(["capbarcup"], lang: :asciimath)],
          mathml: ["&#x2a49;"],
          latex: [["capbarcup", "&#x2a49;"]],
          omml: ["&#x2a49;"],
          html: ["&#x2a49;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\capbarcup"
        end

        def to_asciimath(**)
          parsing_wrapper("capbarcup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a49;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a49;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a49;"
        end

        def to_html(**)
          "&#x2a49;"
        end
      end
    end
  end
end
