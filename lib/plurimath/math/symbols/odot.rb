module Plurimath
  module Math
    module Symbols
      class Odot < Symbol
        INPUT = {
          unicodemath: [["odot", "&#x2299;"], parsing_wrapper(["o."], lang: :unicode)],
          asciimath: [["odot", "o.", "&#x2299;"]],
          mathml: ["&#x2299;"],
          latex: [["odot", "&#x2299;"], parsing_wrapper(["o."], lang: :latex)],
          omml: ["&#x2299;"],
          html: ["&#x2299;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\odot"
        end

        def to_asciimath(**)
          "odot"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2299;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2299;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2299;"
        end

        def to_html(**)
          "&#x2299;"
        end
      end
    end
  end
end
