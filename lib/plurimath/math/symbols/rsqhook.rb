module Plurimath
  module Math
    module Symbols
      class Rsqhook < Symbol
        INPUT = {
          unicodemath: [["&#x2ace;"], parsing_wrapper(["rsqhook"], lang: :unicode)],
          asciimath: [["&#x2ace;"], parsing_wrapper(["rsqhook"], lang: :asciimath)],
          mathml: ["&#x2ace;"],
          latex: [["rsqhook", "&#x2ace;"]],
          omml: ["&#x2ace;"],
          html: ["&#x2ace;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rsqhook"
        end

        def to_asciimath(**)
          parsing_wrapper("rsqhook", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ace;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ace;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ace;"
        end

        def to_html(**)
          "&#x2ace;"
        end
      end
    end
  end
end
