module Plurimath
  module Math
    module Symbols
      class Upequilibrium < Symbol
        INPUT = {
          unicodemath: [["&#x296e;"], parsing_wrapper(["updownharpoonsleftright", "updownharpoons", "upequilibrium"], lang: :unicode)],
          asciimath: [["&#x296e;"], parsing_wrapper(["updownharpoonsleftright", "updownharpoons", "upequilibrium"], lang: :asciimath)],
          mathml: ["&#x296e;"],
          latex: [["updownharpoonsleftright", "updownharpoons", "upequilibrium", "&#x296e;"]],
          omml: ["&#x296e;"],
          html: ["&#x296e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updownharpoonsleftright"
        end

        def to_asciimath(**)
          parsing_wrapper("upequilibrium", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x296e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x296e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x296e;"
        end

        def to_html(**)
          "&#x296e;"
        end
      end
    end
  end
end
