module Plurimath
  module Math
    module Symbols
      class Lge < Symbol
        INPUT = {
          unicodemath: [["&#x2a91;"], parsing_wrapper(["lgE"], lang: :unicode)],
          asciimath: [["&#x2a91;"], parsing_wrapper(["lgE"], lang: :asciimath)],
          mathml: ["&#x2a91;"],
          latex: [["lgE", "&#x2a91;"]],
          omml: ["&#x2a91;"],
          html: ["&#x2a91;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgE"
        end

        def to_asciimath(**)
          parsing_wrapper("lgE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a91;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a91;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a91;"
        end

        def to_html(**)
          "&#x2a91;"
        end
      end
    end
  end
end
