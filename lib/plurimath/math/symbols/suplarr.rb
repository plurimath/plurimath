module Plurimath
  module Math
    module Symbols
      class Suplarr < Symbol
        INPUT = {
          unicodemath: [["&#x297b;"], parsing_wrapper(["suplarr"], lang: :unicode)],
          asciimath: [["&#x297b;"], parsing_wrapper(["suplarr"], lang: :asciimath)],
          mathml: ["&#x297b;"],
          latex: [["suplarr", "&#x297b;"]],
          omml: ["&#x297b;"],
          html: ["&#x297b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\suplarr"
        end

        def to_asciimath(**)
          parsing_wrapper("suplarr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297b;"
        end

        def to_html(**)
          "&#x297b;"
        end
      end
    end
  end
end
