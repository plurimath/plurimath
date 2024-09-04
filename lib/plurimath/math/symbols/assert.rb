module Plurimath
  module Math
    module Symbols
      class Assert < Symbol
        INPUT = {
          unicodemath: [["&#x22a6;"], parsing_wrapper(["assert"], lang: :unicode)],
          asciimath: [["&#x22a6;"], parsing_wrapper(["assert"], lang: :asciimath)],
          mathml: ["&#x22a6;"],
          latex: [["assert", "&#x22a6;"]],
          omml: ["&#x22a6;"],
          html: ["&#x22a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\assert"
        end

        def to_asciimath(**)
          parsing_wrapper("assert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a6;"
        end

        def to_html(**)
          "&#x22a6;"
        end
      end
    end
  end
end
