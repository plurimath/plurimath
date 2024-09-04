module Plurimath
  module Math
    module Symbols
      class Benzenr < Symbol
        INPUT = {
          unicodemath: [["&#x23e3;"], parsing_wrapper(["benzenr"], lang: :unicode)],
          asciimath: [["&#x23e3;"], parsing_wrapper(["benzenr"], lang: :asciimath)],
          mathml: ["&#x23e3;"],
          latex: [["benzenr", "&#x23e3;"]],
          omml: ["&#x23e3;"],
          html: ["&#x23e3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\benzenr"
        end

        def to_asciimath(**)
          parsing_wrapper("benzenr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e3;"
        end

        def to_html(**)
          "&#x23e3;"
        end
      end
    end
  end
end
