# frozen_string_literal: true

require "plurimath/xml_engine"
require "ox"
Ox.default_options = { encoding: "UTF-8" }

module Plurimath
  module XMLEngine
    class Ox
      class << self
        def new_element(name)
          ::Ox::Element.new(name)
        end

        def dump(data, **options)
          ::Ox.dump(data, **options)
        end

        def load(data)
          ::Ox.load(data, strip_namespace: true)
        end

        def is_xml_comment?(node)
          node.is_a?(::Ox::Comment)
        end
      end
    end
  end
end
