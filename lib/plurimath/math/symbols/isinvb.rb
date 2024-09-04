module Plurimath
  module Math
    module Symbols
      class Isinvb < Symbol
        INPUT = {
          unicodemath: [["&#x22f8;"], parsing_wrapper(["isinvb"], lang: :unicode)],
          asciimath: [["&#x22f8;"], parsing_wrapper(["isinvb"], lang: :asciimath)],
          mathml: ["&#x22f8;"],
          latex: [["isinvb", "&#x22f8;"]],
          omml: ["&#x22f8;"],
          html: ["&#x22f8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\isinvb"
        end

        def to_asciimath(**)
          parsing_wrapper("isinvb", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f8;"
        end

        def to_html(**)
          "&#x22f8;"
        end
      end
    end
  end
end
