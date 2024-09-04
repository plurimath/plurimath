module Plurimath
  module Math
    module Symbols
      class Lgwhtcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25ef;"], parsing_wrapper(["lgwhtcircle"], lang: :unicode)],
          asciimath: [["&#x25ef;"], parsing_wrapper(["lgwhtcircle"], lang: :asciimath)],
          mathml: ["&#x25ef;"],
          latex: [["lgwhtcircle", "&#x25ef;"]],
          omml: ["&#x25ef;"],
          html: ["&#x25ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgwhtcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("lgwhtcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ef;"
        end

        def to_html(**)
          "&#x25ef;"
        end
      end
    end
  end
end
