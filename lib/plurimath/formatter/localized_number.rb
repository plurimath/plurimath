module Plurimath
  module Formatter
    class LocalizedNumber < TwitterCldr::Localized::LocalizedNumber
      def to_s(options = {})
        opts = { type: @type, format: @format }.merge(options)

        NumberDataReader
          .new(locale, opts)
          .format_number(base_obj, opts)
      end
    end
  end
end
