module Plurimath
  module Math
    module Symbols
      class Bigwedge < Symbol
        INPUT = {
          unicodemath: [["&#x22c0;"], parsing_wrapper(["bigwedge", "^^^"], lang: :unicode)],
          asciimath: [["bigwedge", "^^^", "&#x22c0;"]],
          mathml: ["&#x22c0;"],
          latex: [["bigwedge", "&#x22c0;"], parsing_wrapper(["^^^"], lang: :latex)],
          omml: ["&#x22c0;"],
          html: ["&#x22c0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigwedge"
        end

        def to_asciimath(**)
          "bigwedge"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c0;"
        end

        def to_html(**)
          "&#x22c0;"
        end

        def nary_intent_name
          ":n-ary"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
