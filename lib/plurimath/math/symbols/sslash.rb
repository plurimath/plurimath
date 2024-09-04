module Plurimath
  module Math
    module Symbols
      class Sslash < Symbol
        INPUT = {
          unicodemath: [["&#x2afd;"], parsing_wrapper(["sslash"], lang: :unicode)],
          asciimath: [["&#x2afd;"], parsing_wrapper(["sslash"], lang: :asciimath)],
          mathml: ["&#x2afd;"],
          latex: [["sslash", "&#x2afd;"]],
          omml: ["&#x2afd;"],
          html: ["&#x2afd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sslash"
        end

        def to_asciimath(**)
          parsing_wrapper("sslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2afd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2afd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2afd;"
        end

        def to_html(**)
          "&#x2afd;"
        end
      end
    end
  end
end
