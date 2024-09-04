module Plurimath
  module Math
    module Symbols
      class Warning < Symbol
        INPUT = {
          unicodemath: [["&#x26a0;"], parsing_wrapper(["warning"], lang: :unicode)],
          asciimath: [["&#x26a0;"], parsing_wrapper(["warning"], lang: :asciimath)],
          mathml: ["&#x26a0;"],
          latex: [["warning", "&#x26a0;"]],
          omml: ["&#x26a0;"],
          html: ["&#x26a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\warning"
        end

        def to_asciimath(**)
          parsing_wrapper("warning", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26a0;"
        end

        def to_html(**)
          "&#x26a0;"
        end
      end
    end
  end
end
