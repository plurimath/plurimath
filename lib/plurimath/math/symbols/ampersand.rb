module Plurimath
  module Math
    module Symbols
      class Ampersand < Symbol
        INPUT = {
          unicodemath: [["&#x26;"], parsing_wrapper(["&", "ampersand"], lang: :unicode)],
          asciimath: [["&", "&#x26;"], parsing_wrapper(["ampersand"], lang: :asciimath)],
          mathml: ["&#x26;"],
          latex: [["ampersand", "&", "&#x26;"]],
          omml: ["&#x26;"],
          html: ["&#x26;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\&"
        end

        def to_asciimath(**)
          "&"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&"
        end

        def to_omml_without_math_tag(_, **)
          "&"
        end

        def to_html(**)
          "&"
        end
      end
    end
  end
end
