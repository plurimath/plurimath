module Plurimath
  module Math
    module Symbols
      class Upuparrows < Symbol
        INPUT = {
          unicodemath: [["upuparrows", "&#x21c8;"]],
          asciimath: [["&#x21c8;"], parsing_wrapper(["upuparrows"], lang: :asciimath)],
          mathml: ["&#x21c8;"],
          latex: [["upuparrows", "&#x21c8;"]],
          omml: ["&#x21c8;"],
          html: ["&#x21c8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upuparrows"
        end

        def to_asciimath(**)
          parsing_wrapper("upuparrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c8;"
        end

        def to_html(**)
          "&#x21c8;"
        end
      end
    end
  end
end
