module Plurimath
  module Math
    module Symbols
      class Lbracemid < Symbol
        INPUT = {
          unicodemath: [["&#x23a8;"], parsing_wrapper(["lbracemid"], lang: :unicode)],
          asciimath: [["&#x23a8;"], parsing_wrapper(["lbracemid"], lang: :asciimath)],
          mathml: ["&#x23a8;"],
          latex: [["lbracemid", "&#x23a8;"]],
          omml: ["&#x23a8;"],
          html: ["&#x23a8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbracemid"
        end

        def to_asciimath(**)
          parsing_wrapper("lbracemid", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a8;"
        end

        def to_html(**)
          "&#x23a8;"
        end
      end
    end
  end
end
