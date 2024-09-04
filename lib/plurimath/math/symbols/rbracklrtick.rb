module Plurimath
  module Math
    module Symbols
      class Rbracklrtick < Symbol
        INPUT = {
          unicodemath: [["&#x298e;"], parsing_wrapper(["rbracklrtick"], lang: :unicode)],
          asciimath: [["&#x298e;"], parsing_wrapper(["rbracklrtick"], lang: :asciimath)],
          mathml: ["&#x298e;"],
          latex: [["rbracklrtick", "&#x298e;"]],
          omml: ["&#x298e;"],
          html: ["&#x298e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbracklrtick"
        end

        def to_asciimath(**)
          parsing_wrapper("rbracklrtick", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x298e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x298e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x298e;"
        end

        def to_html(**)
          "&#x298e;"
        end
      end
    end
  end
end
