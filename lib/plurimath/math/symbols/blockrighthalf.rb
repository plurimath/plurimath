module Plurimath
  module Math
    module Symbols
      class Blockrighthalf < Symbol
        INPUT = {
          unicodemath: [["&#x2590;"], parsing_wrapper(["blockrighthalf"], lang: :unicode)],
          asciimath: [["&#x2590;"], parsing_wrapper(["blockrighthalf"], lang: :asciimath)],
          mathml: ["&#x2590;"],
          latex: [["blockrighthalf", "&#x2590;"]],
          omml: ["&#x2590;"],
          html: ["&#x2590;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockrighthalf"
        end

        def to_asciimath(**)
          parsing_wrapper("blockrighthalf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2590;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2590;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2590;"
        end

        def to_html(**)
          "&#x2590;"
        end
      end
    end
  end
end
