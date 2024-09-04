module Plurimath
  module Math
    module Symbols
      class Lsqhook < Symbol
        INPUT = {
          unicodemath: [["&#x2acd;"], parsing_wrapper(["lsqhook"], lang: :unicode)],
          asciimath: [["&#x2acd;"], parsing_wrapper(["lsqhook"], lang: :asciimath)],
          mathml: ["&#x2acd;"],
          latex: [["lsqhook", "&#x2acd;"]],
          omml: ["&#x2acd;"],
          html: ["&#x2acd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lsqhook"
        end

        def to_asciimath(**)
          parsing_wrapper("lsqhook", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2acd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2acd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2acd;"
        end

        def to_html(**)
          "&#x2acd;"
        end
      end
    end
  end
end
