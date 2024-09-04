module Plurimath
  module Math
    module Symbols
      class Squarellquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f1;"], parsing_wrapper(["squarellquad"], lang: :unicode)],
          asciimath: [["&#x25f1;"], parsing_wrapper(["squarellquad"], lang: :asciimath)],
          mathml: ["&#x25f1;"],
          latex: [["squarellquad", "&#x25f1;"]],
          omml: ["&#x25f1;"],
          html: ["&#x25f1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarellquad"
        end

        def to_asciimath(**)
          parsing_wrapper("squarellquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f1;"
        end

        def to_html(**)
          "&#x25f1;"
        end
      end
    end
  end
end
