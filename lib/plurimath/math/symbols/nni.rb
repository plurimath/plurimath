module Plurimath
  module Math
    module Symbols
      class Nni < Symbol
        INPUT = {
          unicodemath: [["notni", "&#x220c;"], parsing_wrapper(["nni"], lang: :unicode)],
          asciimath: [["&#x220c;"], parsing_wrapper(["notni", "nni"], lang: :asciimath)],
          mathml: ["&#x220c;"],
          latex: [["notni", "nni", "&#x220c;"]],
          omml: ["&#x220c;"],
          html: ["&#x220c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\notni"
        end

        def to_asciimath(**)
          parsing_wrapper("nni", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x220c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x220c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x220c;"
        end

        def to_html(**)
          "&#x220c;"
        end
      end
    end
  end
end
