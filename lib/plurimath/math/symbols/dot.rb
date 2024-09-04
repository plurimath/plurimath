module Plurimath
  module Math
    module Symbols
      class Dot < Symbol
        INPUT = {
          unicodemath: [["&#x307;"], parsing_wrapper(["Dot"], lang: :unicode)],
          asciimath: [["&#x307;"], parsing_wrapper(["Dot"], lang: :asciimath)],
          mathml: ["&#x307;"],
          latex: [["Dot", "&#x307;"]],
          omml: ["&#x307;"],
          html: ["&#x307;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\period"
        end

        def to_asciimath(**)
          "."
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x307;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x307;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x307;"
        end

        def to_html(**)
          "&#x307;"
        end
      end
    end
  end
end
