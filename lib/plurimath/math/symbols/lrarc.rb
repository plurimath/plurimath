module Plurimath
  module Math
    module Symbols
      class Lrarc < Symbol
        INPUT = {
          unicodemath: [["&#x25de;"], parsing_wrapper(["lrarc"], lang: :unicode)],
          asciimath: [["&#x25de;"], parsing_wrapper(["lrarc"], lang: :asciimath)],
          mathml: ["&#x25de;"],
          latex: [["lrarc", "&#x25de;"]],
          omml: ["&#x25de;"],
          html: ["&#x25de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lrarc"
        end

        def to_asciimath(**)
          parsing_wrapper("lrarc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25de;"
        end

        def to_html(**)
          "&#x25de;"
        end
      end
    end
  end
end
