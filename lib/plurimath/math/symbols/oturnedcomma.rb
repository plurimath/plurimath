module Plurimath
  module Math
    module Symbols
      class Oturnedcomma < Symbol
        INPUT = {
          unicodemath: [["&#x312;"], parsing_wrapper(["oturnedcomma"], lang: :unicode)],
          asciimath: [["&#x312;"], parsing_wrapper(["oturnedcomma"], lang: :asciimath)],
          mathml: ["&#x312;"],
          latex: [["oturnedcomma", "&#x312;"]],
          omml: ["&#x312;"],
          html: ["&#x312;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\oturnedcomma"
        end

        def to_asciimath(**)
          parsing_wrapper("oturnedcomma", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x312;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x312;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x312;"
        end

        def to_html(**)
          "&#x312;"
        end
      end
    end
  end
end
