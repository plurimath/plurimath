module Plurimath
  module Math
    module Symbols
      class Lrhar < Symbol
        INPUT = {
          unicodemath: [["leftrightharpoons", "lrhar", "&#x21cb;"], parsing_wrapper(["revequilibrium"])],
          asciimath: [["&#x21cb;"], parsing_wrapper(["leftrightharpoons", "lrhar", "revequilibrium"])],
          mathml: ["&#x21cb;"],
          latex: [["leftrightharpoons", "revequilibrium", "&#x21cb;"], parsing_wrapper(["lrhar"])],
          omml: ["&#x21cb;"],
          html: ["&#x21cb;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftrightharpoons"
        end

        def to_asciimath
          parsing_wrapper("lrhar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21cb;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x21cb;"
        end

        def to_omml_without_math_tag(_)
          "&#x21cb;"
        end

        def to_html
          "&#x21cb;"
        end
      end
    end
  end
end
