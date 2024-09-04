module Plurimath
  module Math
    module Symbols
      class Rightarrowdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x291e;"], parsing_wrapper(["rightarrowdiamond"], lang: :unicode)],
          asciimath: [["&#x291e;"], parsing_wrapper(["rightarrowdiamond"], lang: :asciimath)],
          mathml: ["&#x291e;"],
          latex: [["rightarrowdiamond", "&#x291e;"]],
          omml: ["&#x291e;"],
          html: ["&#x291e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowdiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x291e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x291e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x291e;"
        end

        def to_html(**)
          "&#x291e;"
        end
      end
    end
  end
end
