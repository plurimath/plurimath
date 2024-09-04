module Plurimath
  module Math
    module Symbols
      class Mercury < Symbol
        INPUT = {
          unicodemath: [["&#x263f;"], parsing_wrapper(["mercury", "Mercury"], lang: :unicode)],
          asciimath: [["&#x263f;"], parsing_wrapper(["mercury", "Mercury"], lang: :asciimath)],
          mathml: ["&#x263f;"],
          latex: [["mercury", "Mercury", "&#x263f;"]],
          omml: ["&#x263f;"],
          html: ["&#x263f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mercury"
        end

        def to_asciimath(**)
          parsing_wrapper("Mercury", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x263f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x263f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x263f;"
        end

        def to_html(**)
          "&#x263f;"
        end
      end
    end
  end
end
