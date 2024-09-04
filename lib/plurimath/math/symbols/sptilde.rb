module Plurimath
  module Math
    module Symbols
      class Sptilde < Symbol
        INPUT = {
          unicodemath: [["&#x7e;"], parsing_wrapper(["~", "sptilde"], lang: :unicode)],
          asciimath: [["~", "&#x7e;"], parsing_wrapper(["sptilde"], lang: :asciimath)],
          mathml: ["&#x7e;"],
          latex: [["sptilde", "&#x7e;"], parsing_wrapper(["~"], lang: :latex)],
          omml: ["&#x7e;"],
          html: ["&#x7e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sptilde"
        end

        def to_asciimath(**)
          "~"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x7e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x7e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x7e;"
        end

        def to_html(**)
          "&#x7e;"
        end
      end
    end
  end
end
