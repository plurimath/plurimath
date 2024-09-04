module Plurimath
  module Math
    module Symbols
      class Angstrom < Symbol
        INPUT = {
          unicodemath: [["&#x212b;"], parsing_wrapper(["Angstroem", "Angstrom"], lang: :unicode)],
          asciimath: [["&#x212b;"], parsing_wrapper(["Angstroem", "Angstrom"], lang: :asciimath)],
          mathml: ["&#x212b;"],
          latex: [["Angstroem", "Angstrom", "&#x212b;"]],
          omml: ["&#x212b;"],
          html: ["&#x212b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Angstroem"
        end

        def to_asciimath(**)
          parsing_wrapper("Angstrom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x212b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x212b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x212b;"
        end

        def to_html(**)
          "&#x212b;"
        end
      end
    end
  end
end
