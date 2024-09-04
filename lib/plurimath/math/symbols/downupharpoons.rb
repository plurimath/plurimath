module Plurimath
  module Math
    module Symbols
      class Downupharpoons < Symbol
        INPUT = {
          unicodemath: [["&#x296f;"], parsing_wrapper(["downupharpoonsleftright", "uprevequilibrium", "downupharpoons"], lang: :unicode)],
          asciimath: [["&#x296f;"], parsing_wrapper(["downupharpoonsleftright", "uprevequilibrium", "downupharpoons"], lang: :asciimath)],
          mathml: ["&#x296f;"],
          latex: [["downupharpoonsleftright", "uprevequilibrium", "downupharpoons", "&#x296f;"]],
          omml: ["&#x296f;"],
          html: ["&#x296f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downupharpoonsleftright"
        end

        def to_asciimath(**)
          parsing_wrapper("downupharpoons", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x296f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x296f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x296f;"
        end

        def to_html(**)
          "&#x296f;"
        end
      end
    end
  end
end
