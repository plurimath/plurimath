module Plurimath
  module Math
    module Function
    end
  end
end

# Include the first level files before the next
(
  Dir.glob(File.join(__dir__, "function", "*.rb")) +
  Dir.glob(File.join(__dir__, "function", "*", "*.rb"))
).each do |file|
  require file
end
