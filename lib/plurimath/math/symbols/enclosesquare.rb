module Plurimath
  module Math
    module Symbols
      class Enclosesquare < Symbol
        INPUT = {
          unicodemath: [["&#x20de;"], parsing_wrapper(["enclosesquare"], lang: :unicode)],
          asciimath: [["&#x20de;"], parsing_wrapper(["enclosesquare"], lang: :asciimath)],
          mathml: ["&#x20de;"],
          latex: [["enclosesquare", "&#x20de;"]],
          omml: ["&#x20de;"],
          html: ["&#x20de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\enclosesquare"
        end

        def to_asciimath(**)
          parsing_wrapper("enclosesquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20de;"
        end

        def to_html(**)
          "&#x20de;"
        end
      end
    end
  end
end
