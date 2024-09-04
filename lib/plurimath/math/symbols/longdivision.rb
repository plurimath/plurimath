module Plurimath
  module Math
    module Symbols
      class Longdivision < Symbol
        INPUT = {
          unicodemath: [["&#x27cc;"], parsing_wrapper(["longdivision"], lang: :unicode)],
          asciimath: [["&#x27cc;"], parsing_wrapper(["longdivision"], lang: :asciimath)],
          mathml: ["&#x27cc;"],
          latex: [["longdivision", "&#x27cc;"]],
          omml: ["&#x27cc;"],
          html: ["&#x27cc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\longdivision"
        end

        def to_asciimath(**)
          parsing_wrapper("longdivision", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27cc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27cc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27cc;"
        end

        def to_html(**)
          "&#x27cc;"
        end
      end
    end
  end
end
