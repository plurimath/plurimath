module Plurimath
  module Math
    module Symbols
      class Blackinwhitesquare < Symbol
        INPUT = {
          unicodemath: [["&#x25a3;"], parsing_wrapper(["blackinwhitesquare"], lang: :unicode)],
          asciimath: [["&#x25a3;"], parsing_wrapper(["blackinwhitesquare"], lang: :asciimath)],
          mathml: ["&#x25a3;"],
          latex: [["blackinwhitesquare", "&#x25a3;"]],
          omml: ["&#x25a3;"],
          html: ["&#x25a3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackinwhitesquare"
        end

        def to_asciimath(**)
          parsing_wrapper("blackinwhitesquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a3;"
        end

        def to_html(**)
          "&#x25a3;"
        end
      end
    end
  end
end
