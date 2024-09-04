module Plurimath
  module Math
    module Symbols
      class Mdwhtsquare < Symbol
        INPUT = {
          unicodemath: [["&#x25fb;"], parsing_wrapper(["mdwhtsquare", "square"], lang: :unicode)],
          asciimath: [["&#x25fb;"], parsing_wrapper(["mdwhtsquare", "square"], lang: :asciimath)],
          mathml: ["&#x25fb;"],
          latex: [["mdwhtsquare", "square", "&#x25fb;"]],
          omml: ["&#x25fb;"],
          html: ["&#x25fb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdwhtsquare"
        end

        def to_asciimath(**)
          parsing_wrapper("mdwhtsquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25fb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25fb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25fb;"
        end

        def to_html(**)
          "&#x25fb;"
        end
      end
    end
  end
end
