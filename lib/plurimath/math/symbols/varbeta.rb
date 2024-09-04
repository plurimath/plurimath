module Plurimath
  module Math
    module Symbols
      class Varbeta < Symbol
        INPUT = {
          unicodemath: [["&#x3d0;"], parsing_wrapper(["upvarbeta", "varbeta"], lang: :unicode)],
          asciimath: [["&#x3d0;"], parsing_wrapper(["upvarbeta", "varbeta"], lang: :asciimath)],
          mathml: ["&#x3d0;"],
          latex: [["upvarbeta", "varbeta", "&#x3d0;"]],
          omml: ["&#x3d0;"],
          html: ["&#x3d0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvarbeta"
        end

        def to_asciimath(**)
          parsing_wrapper("varbeta", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3d0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3d0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3d0;"
        end

        def to_html(**)
          "&#x3d0;"
        end
      end
    end
  end
end
