module Plurimath
  singleton_class.attr_accessor :xml_engine

  module XmlEngine
    autoload :Oga, File.expand_path("xml_engine/oga", __dir__)
    autoload :OxEngine, File.expand_path("xml_engine/ox_engine", __dir__)
  end
end
