module Plurimath
  module Math
    module Symbols
      class Gtrdot < Symbol
        INPUT = {
          unicodemath: [["gtrdot", "&#x22d7;"]],
          asciimath: [["&#x22d7;"], parsing_wrapper(["gtrdot"], lang: :asciimath)],
          mathml: ["&#x22d7;"],
          latex: [["gtrdot", "&#x22d7;"]],
          omml: ["&#x22d7;"],
          html: ["&#x22d7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtrdot"
        end

        def to_asciimath(**)
          parsing_wrapper("gtrdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d7;"
        end

        def to_html(**)
          "&#x22d7;"
        end
      end
    end
  end
end
