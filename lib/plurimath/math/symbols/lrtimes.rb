module Plurimath
  module Math
    module Symbols
      class Lrtimes < Symbol
        INPUT = {
          unicodemath: [["bowtie", "&#x22c8;"], parsing_wrapper(["|><|", "lrtimes"], lang: :unicode)],
          asciimath: [["bowtie", "|><|", "&#x22c8;"], parsing_wrapper(["lrtimes"], lang: :asciimath)],
          mathml: ["&#x22c8;"],
          latex: [["lrtimes", "bowtie", "&#x22c8;"], parsing_wrapper(["|><|"], lang: :latex)],
          omml: ["&#x22c8;"],
          html: ["&#x22c8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lrtimes"
        end

        def to_asciimath(**)
          "bowtie"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c8;"
        end

        def to_html(**)
          "&#x22c8;"
        end
      end
    end
  end
end
