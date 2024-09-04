module Plurimath
  module Math
    module Symbols
      class Ddotseq < Symbol
        INPUT = {
          unicodemath: [["&#x2a77;"], parsing_wrapper(["ddotseq"], lang: :unicode)],
          asciimath: [["&#x2a77;"], parsing_wrapper(["ddotseq"], lang: :asciimath)],
          mathml: ["&#x2a77;"],
          latex: [["ddotseq", "&#x2a77;"]],
          omml: ["&#x2a77;"],
          html: ["&#x2a77;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ddotseq"
        end

        def to_asciimath(**)
          parsing_wrapper("ddotseq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a77;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a77;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a77;"
        end

        def to_html(**)
          "&#x2a77;"
        end
      end
    end
  end
end
