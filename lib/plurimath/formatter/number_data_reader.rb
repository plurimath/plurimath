# frozen_string_literal: true

module Plurimath
  module Formatter
    class NumberDataReader < TwitterCldr::DataReaders::NumberDataReader
      def formatter
        NumberFormatter.new(self)
      end
    end
  end
end
