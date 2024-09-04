module Plurimath
  module Math
    module Symbols
      class Sun < Symbol
        INPUT = {
          unicodemath: [["&#x263c;"], parsing_wrapper(["sun"], lang: :unicode)],
          asciimath: [["&#x263c;"], parsing_wrapper(["sun"], lang: :asciimath)],
          mathml: ["&#x263c;"],
          latex: [["sun", "&#x263c;"]],
          omml: ["&#x263c;"],
          html: ["&#x263c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sun"
        end

        def to_asciimath(**)
          parsing_wrapper("sun", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263c;"
        end

        def to_html(**)
          "&#x263c;"
        end
      end
    end
  end
end
