module Plurimath
  module Math
    module Symbols
      class Capovercup < Symbol
        INPUT = {
          unicodemath: [["&#x2a47;"], parsing_wrapper(["capovercup"], lang: :unicode)],
          asciimath: [["&#x2a47;"], parsing_wrapper(["capovercup"], lang: :asciimath)],
          mathml: ["&#x2a47;"],
          latex: [["capovercup", "&#x2a47;"]],
          omml: ["&#x2a47;"],
          html: ["&#x2a47;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\capovercup"
        end

        def to_asciimath(**)
          parsing_wrapper("capovercup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a47;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a47;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a47;"
        end

        def to_html(**)
          "&#x2a47;"
        end
      end
    end
  end
end
