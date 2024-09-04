module Plurimath
  module Math
    module Symbols
      class Fbowtie < Symbol
        INPUT = {
          unicodemath: [["&#x29d3;"], parsing_wrapper(["fbowtie"], lang: :unicode)],
          asciimath: [["&#x29d3;"], parsing_wrapper(["fbowtie"], lang: :asciimath)],
          mathml: ["&#x29d3;"],
          latex: [["fbowtie", "&#x29d3;"]],
          omml: ["&#x29d3;"],
          html: ["&#x29d3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fbowtie"
        end

        def to_asciimath(**)
          parsing_wrapper("fbowtie", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29d3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29d3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29d3;"
        end

        def to_html(**)
          "&#x29d3;"
        end
      end
    end
  end
end
