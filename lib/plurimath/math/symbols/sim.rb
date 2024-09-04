module Plurimath
  module Math
    module Symbols
      class Sim < Symbol
        INPUT = {
          unicodemath: [["sim", "&#x223c;"]],
          asciimath: [["&#x223c;"], parsing_wrapper(["sim"], lang: :asciimath)],
          mathml: ["&#x223c;"],
          latex: [["sim", "&#x223c;"]],
          omml: ["&#x223c;"],
          html: ["&#x223c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sim"
        end

        def to_asciimath(**)
          parsing_wrapper("sim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x223c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x223c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x223c;"
        end

        def to_html(**)
          "&#x223c;"
        end
      end
    end
  end
end
