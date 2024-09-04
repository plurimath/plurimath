module Plurimath
  module Math
    module Symbols
      class Risingdotseq < Symbol
        INPUT = {
          unicodemath: [["risingdotseq", "&#x2253;"]],
          asciimath: [["&#x2253;"], parsing_wrapper(["risingdotseq"], lang: :asciimath)],
          mathml: ["&#x2253;"],
          latex: [["risingdotseq", "&#x2253;"]],
          omml: ["&#x2253;"],
          html: ["&#x2253;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\risingdotseq"
        end

        def to_asciimath(**)
          parsing_wrapper("risingdotseq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2253;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2253;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2253;"
        end

        def to_html(**)
          "&#x2253;"
        end
      end
    end
  end
end
