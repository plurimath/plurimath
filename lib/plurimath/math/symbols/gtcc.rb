module Plurimath
  module Math
    module Symbols
      class Gtcc < Symbol
        INPUT = {
          unicodemath: [["&#x2aa7;"], parsing_wrapper(["rightslice", "gtcc"], lang: :unicode)],
          asciimath: [["&#x2aa7;"], parsing_wrapper(["rightslice", "gtcc"], lang: :asciimath)],
          mathml: ["&#x2aa7;"],
          latex: [["rightslice", "gtcc", "&#x2aa7;"]],
          omml: ["&#x2aa7;"],
          html: ["&#x2aa7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightslice"
        end

        def to_asciimath(**)
          parsing_wrapper("gtcc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa7;"
        end

        def to_html(**)
          "&#x2aa7;"
        end
      end
    end
  end
end
