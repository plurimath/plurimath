module Plurimath
  module Math
    module Symbols
      class Suphsub < Symbol
        INPUT = {
          unicodemath: [["&#x2ad7;"], parsing_wrapper(["suphsub"], lang: :unicode)],
          asciimath: [["&#x2ad7;"], parsing_wrapper(["suphsub"], lang: :asciimath)],
          mathml: ["&#x2ad7;"],
          latex: [["suphsub", "&#x2ad7;"]],
          omml: ["&#x2ad7;"],
          html: ["&#x2ad7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\suphsub"
        end

        def to_asciimath(**)
          parsing_wrapper("suphsub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad7;"
        end

        def to_html(**)
          "&#x2ad7;"
        end
      end
    end
  end
end
