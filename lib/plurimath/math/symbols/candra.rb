module Plurimath
  module Math
    module Symbols
      class Candra < Symbol
        INPUT = {
          unicodemath: [["&#x310;"], parsing_wrapper(["candra"], lang: :unicode)],
          asciimath: [["&#x310;"], parsing_wrapper(["candra"], lang: :asciimath)],
          mathml: ["&#x310;"],
          latex: [["candra", "&#x310;"]],
          omml: ["&#x310;"],
          html: ["&#x310;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\candra"
        end

        def to_asciimath(**)
          parsing_wrapper("candra", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x310;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x310;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x310;"
        end

        def to_html(**)
          "&#x310;"
        end
      end
    end
  end
end
