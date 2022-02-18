Dir[File.join(__dir__, "function/*.rb")].each{|f| require_relative f}
