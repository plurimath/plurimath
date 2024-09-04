module Plurimath
  module Math
    module Symbols
      class Revnmid < Symbol
        INPUT = {
          unicodemath: [["&#x2aee;"], parsing_wrapper(["revnmid"], lang: :unicode)],
          asciimath: [["&#x2aee;"], parsing_wrapper(["revnmid"], lang: :asciimath)],
          mathml: ["&#x2aee;"],
          latex: [["revnmid", "&#x2aee;"]],
          omml: ["&#x2aee;"],
          html: ["&#x2aee;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\revnmid"
        end

        def to_asciimath(**)
          parsing_wrapper("revnmid", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aee;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aee;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aee;"
        end

        def to_html(**)
          "&#x2aee;"
        end
      end
    end
  end
end
