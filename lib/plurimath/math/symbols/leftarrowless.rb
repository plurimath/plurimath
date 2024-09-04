module Plurimath
  module Math
    module Symbols
      class Leftarrowless < Symbol
        INPUT = {
          unicodemath: [["&#x2977;"], parsing_wrapper(["leftarrowless"], lang: :unicode)],
          asciimath: [["&#x2977;"], parsing_wrapper(["leftarrowless"], lang: :asciimath)],
          mathml: ["&#x2977;"],
          latex: [["leftarrowless", "&#x2977;"]],
          omml: ["&#x2977;"],
          html: ["&#x2977;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowless"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2977;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2977;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2977;"
        end

        def to_html(**)
          "&#x2977;"
        end
      end
    end
  end
end
