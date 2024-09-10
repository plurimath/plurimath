module Plurimath
  module Math
    module Symbols
      class Ubrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x23e1;"], parsing_wrapper(["ubrbrak"], lang: :unicode)],
          asciimath: [["&#x23e1;"], parsing_wrapper(["ubrbrak"], lang: :asciimath)],
          mathml: ["&#x23e1;"],
          latex: [["ubrbrak", "&#x23e1;"]],
          omml: ["&#x23e1;"],
          html: ["&#x23e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ubrbrak"
        end

        def to_asciimath(**)
          parsing_wrapper("ubrbrak", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e1;"
        end

        def to_html(**)
          "&#x23e1;"
        end
      end
    end
  end
end
