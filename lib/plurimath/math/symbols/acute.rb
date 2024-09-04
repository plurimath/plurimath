module Plurimath
  module Math
    module Symbols
      class Acute < Symbol
        INPUT = {
          unicodemath: [["&#x301;"], parsing_wrapper(["acute"], lang: :unicode)],
          asciimath: [["&#x301;"], parsing_wrapper(["acute"], lang: :asciimath)],
          mathml: ["&#x301;"],
          latex: [["acute", "&#x301;"]],
          omml: ["&#x301;"],
          html: ["&#x301;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acute"
        end

        def to_asciimath(**)
          parsing_wrapper("acute", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x301;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x301;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x301;"
        end

        def to_html(**)
          "&#x301;"
        end
      end
    end
  end
end
