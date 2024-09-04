module Plurimath
  module Math
    module Symbols
      class Breve < Symbol
        INPUT = {
          unicodemath: [["&#x306;"], parsing_wrapper(["breve"], lang: :unicode)],
          asciimath: [["&#x306;"], parsing_wrapper(["breve"], lang: :asciimath)],
          mathml: ["&#x306;"],
          latex: [["breve", "&#x306;"]],
          omml: ["&#x306;"],
          html: ["&#x306;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\breve"
        end

        def to_asciimath(**)
          parsing_wrapper("breve", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x306;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x306;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x306;"
        end

        def to_html(**)
          "&#x306;"
        end
      end
    end
  end
end
