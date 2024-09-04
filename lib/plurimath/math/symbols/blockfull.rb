module Plurimath
  module Math
    module Symbols
      class Blockfull < Symbol
        INPUT = {
          unicodemath: [["&#x2588;"], parsing_wrapper(["blockfull"], lang: :unicode)],
          asciimath: [["&#x2588;"], parsing_wrapper(["blockfull"], lang: :asciimath)],
          mathml: ["&#x2588;"],
          latex: [["blockfull", "&#x2588;"]],
          omml: ["&#x2588;"],
          html: ["&#x2588;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockfull"
        end

        def to_asciimath(**)
          parsing_wrapper("blockfull", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2588;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2588;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2588;"
        end

        def to_html(**)
          "&#x2588;"
        end
      end
    end
  end
end
