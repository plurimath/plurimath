module Plurimath
  module Math
    module Symbols
      class Downuparrows < Symbol
        INPUT = {
          unicodemath: [["&#x21f5;"], parsing_wrapper(["downarrowuparrow", "downuparrows"], lang: :unicode)],
          asciimath: [["&#x21f5;"], parsing_wrapper(["downarrowuparrow", "downuparrows"], lang: :asciimath)],
          mathml: ["&#x21f5;"],
          latex: [["downarrowuparrow", "downuparrows", "&#x21f5;"]],
          omml: ["&#x21f5;"],
          html: ["&#x21f5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downarrowuparrow"
        end

        def to_asciimath(**)
          parsing_wrapper("downuparrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21f5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21f5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21f5;"
        end

        def to_html(**)
          "&#x21f5;"
        end
      end
    end
  end
end
