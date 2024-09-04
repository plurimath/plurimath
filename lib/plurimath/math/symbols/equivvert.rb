module Plurimath
  module Math
    module Symbols
      class Equivvert < Symbol
        INPUT = {
          unicodemath: [["&#x2a68;"], parsing_wrapper(["equivVert"], lang: :unicode)],
          asciimath: [["&#x2a68;"], parsing_wrapper(["equivVert"], lang: :asciimath)],
          mathml: ["&#x2a68;"],
          latex: [["equivVert", "&#x2a68;"]],
          omml: ["&#x2a68;"],
          html: ["&#x2a68;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equivVert"
        end

        def to_asciimath(**)
          parsing_wrapper("equivVert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a68;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a68;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a68;"
        end

        def to_html(**)
          "&#x2a68;"
        end
      end
    end
  end
end
