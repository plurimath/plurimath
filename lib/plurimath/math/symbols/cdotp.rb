module Plurimath
  module Math
    module Symbols
      class Cdotp < Symbol
        INPUT = {
          unicodemath: [["&#xb7;"], parsing_wrapper(["cdotp"], lang: :unicode)],
          asciimath: [["&#xb7;"], parsing_wrapper(["cdotp"], lang: :asciimath)],
          mathml: ["&#xb7;"],
          latex: [["cdotp", "&#xb7;"]],
          omml: ["&#xb7;"],
          html: ["&#xb7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cdotp"
        end

        def to_asciimath(**)
          parsing_wrapper("cdotp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xb7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xb7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xb7;"
        end

        def to_html(**)
          "&#xb7;"
        end
      end
    end
  end
end
