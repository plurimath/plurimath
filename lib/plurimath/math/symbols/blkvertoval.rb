module Plurimath
  module Math
    module Symbols
      class Blkvertoval < Symbol
        INPUT = {
          unicodemath: [["&#x2b2e;"], parsing_wrapper(["blkvertoval"], lang: :unicode)],
          asciimath: [["&#x2b2e;"], parsing_wrapper(["blkvertoval"], lang: :asciimath)],
          mathml: ["&#x2b2e;"],
          latex: [["blkvertoval", "&#x2b2e;"]],
          omml: ["&#x2b2e;"],
          html: ["&#x2b2e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blkvertoval"
        end

        def to_asciimath(**)
          parsing_wrapper("blkvertoval", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2e;"
        end

        def to_html(**)
          "&#x2b2e;"
        end
      end
    end
  end
end
