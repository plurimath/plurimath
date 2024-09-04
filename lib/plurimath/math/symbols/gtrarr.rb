module Plurimath
  module Math
    module Symbols
      class Gtrarr < Symbol
        INPUT = {
          unicodemath: [["&#x2978;"], parsing_wrapper(["gtrarr"], lang: :unicode)],
          asciimath: [["&#x2978;"], parsing_wrapper(["gtrarr"], lang: :asciimath)],
          mathml: ["&#x2978;"],
          latex: [["gtrarr", "&#x2978;"]],
          omml: ["&#x2978;"],
          html: ["&#x2978;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtrarr"
        end

        def to_asciimath(**)
          parsing_wrapper("gtrarr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2978;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2978;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2978;"
        end

        def to_html(**)
          "&#x2978;"
        end
      end
    end
  end
end
