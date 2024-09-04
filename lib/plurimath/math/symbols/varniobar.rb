module Plurimath
  module Math
    module Symbols
      class Varniobar < Symbol
        INPUT = {
          unicodemath: [["&#x22fd;"], parsing_wrapper(["varniobar"], lang: :unicode)],
          asciimath: [["&#x22fd;"], parsing_wrapper(["varniobar"], lang: :asciimath)],
          mathml: ["&#x22fd;"],
          latex: [["varniobar", "&#x22fd;"]],
          omml: ["&#x22fd;"],
          html: ["&#x22fd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varniobar"
        end

        def to_asciimath(**)
          parsing_wrapper("varniobar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22fd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22fd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22fd;"
        end

        def to_html(**)
          "&#x22fd;"
        end
      end
    end
  end
end
