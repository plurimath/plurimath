Dir[File.join(__dir__, "function/*.rb")].each do |file|
  require_relative file.gsub(".rb", "")
end
