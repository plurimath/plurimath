module Plurimath
  module Math
    module Symbols
      class Not < Symbol
        INPUT = {
          unicodemath: [["neg", "&#xac;"], parsing_wrapper(["not", "lnot"], lang: :unicode)],
          asciimath: [["neg", "not", "&#xac;"], parsing_wrapper(["lnot"], lang: :asciimath)],
          mathml: ["&#xac;"],
          latex: [["lnot", "neg", "&#xac;"], parsing_wrapper(["not"], lang: :latex)],
          omml: ["&#xac;"],
          html: ["&#xac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lnot"
        end

        def to_asciimath(**)
          "neg"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xac;"
        end

        def to_html(**)
          "&#xac;"
        end
      end
    end
  end
end
