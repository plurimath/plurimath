module Plurimath
  module Math
    module Symbols
      class Check < Symbol
        INPUT = {
          unicodemath: [["&#x30c;"], parsing_wrapper(["check"], lang: :unicode)],
          asciimath: [["&#x30c;"], parsing_wrapper(["check"], lang: :asciimath)],
          mathml: ["&#x30c;"],
          latex: [["check", "&#x30c;"]],
          omml: ["&#x30c;"],
          html: ["&#x30c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\check"
        end

        def to_asciimath(**)
          parsing_wrapper("check", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x30c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x30c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x30c;"
        end

        def to_html(**)
          "&#x30c;"
        end
      end
    end
  end
end
