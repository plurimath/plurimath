module Plurimath
  module Math
    module Symbols
      class Bigwedge < Symbol
        INPUT = {
          unicodemath: [["&#x22c0;"], parsing_wrapper(["bigwedge", "^^^"])],
          asciimath: [["bigwedge", "^^^", "&#x22c0;"]],
          mathml: ["&#x22c0;"],
          latex: [["bigwedge", "&#x22c0;"], parsing_wrapper(["^^^"])],
          omml: ["&#x22c0;"],
          html: ["&#x22c0;"],
        }.freeze

        # output methods
        def to_latex
          "\\bigwedge"
        end

        def to_asciimath
          "bigwedge"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22c0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22c0;"
        end

        def to_omml_without_math_tag(_)
          "&#x22c0;"
        end

        def to_html
          "&#x22c0;"
        end
      end
    end
  end
end
