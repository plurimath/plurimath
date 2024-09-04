module Plurimath
  module Math
    module Symbols
      class Libra < Symbol
        INPUT = {
          unicodemath: [["&#x264e;"], parsing_wrapper(["libra", "Libra"], lang: :unicode)],
          asciimath: [["&#x264e;"], parsing_wrapper(["libra", "Libra"], lang: :asciimath)],
          mathml: ["&#x264e;"],
          latex: [["libra", "Libra", "&#x264e;"]],
          omml: ["&#x264e;"],
          html: ["&#x264e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\libra"
        end

        def to_asciimath(**)
          parsing_wrapper("Libra", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x264e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x264e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x264e;"
        end

        def to_html(**)
          "&#x264e;"
        end
      end
    end
  end
end
