module Plurimath
  module Math
    module Symbols
      class Downrightteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295f;"], parsing_wrapper(["barrightharpoondown", "DownRightTeeVector"], lang: :unicode)],
          asciimath: [["&#x295f;"], parsing_wrapper(["barrightharpoondown", "DownRightTeeVector"], lang: :asciimath)],
          mathml: ["&#x295f;"],
          latex: [["barrightharpoondown", "DownRightTeeVector", "&#x295f;"]],
          omml: ["&#x295f;"],
          html: ["&#x295f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barrightharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("DownRightTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x295f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x295f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x295f;"
        end

        def to_html(**)
          "&#x295f;"
        end
      end
    end
  end
end
