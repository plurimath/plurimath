require "erb"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "opal/rspec/rake_task"
require_relative "lib/plurimath"

RSpec::Core::RakeTask.new(:spec)

# Opal testing support
begin
  Opal::RSpec::RakeTask.new(:"spec-opal")
rescue LoadError
  # Likely the dependencies haven't been upstreamed yet. Ensure you
  # run those tests via the `plurimath-js` repo's `env/plurimath`
  # script.
end

DOC_FILES = {
  "supported_parens_list.adoc" => :paren,
  "supported_symbols_list.adoc" => :symbols,
}.freeze

DOC_FILES.each do |file_name, type|
  file file_name => [] do
    write_doc_file(file_name, type: type)
  end
end

def write_doc_file(doc_file, type:)
  File.open(doc_file, "a") do |file|
    file.write(file_header)

    Plurimath::Utility.send(:"#{type}_files").each do |klass|
      next if klass::INPUT.empty?
      
      file_name = File.basename(klass.const_source_location(:INPUT).first, ".rb")
      file.write(documentation_content(file_name, klass))
    end

    file.write("|===")
  end
end

def documentation_content(file_name, klass)
  <<~DOCUMENTATION
    | #{Plurimath::Utility.capitalize(file_name)}
    | `#{Plurimath::Utility.hexcode_in_input(klass) || klass.input(:asciimath).first}`
    #{input_for_formats(klass)}
  DOCUMENTATION
end

def file_header
  <<~HEADER
    |===
    | Math symbol name | Unicode character | AsciiMath | LaTeX | MathML | OMML | UnicodeMath

  HEADER
end

def input_for_formats(klass)
  %i[asciimath latex mathml omml unicodemath].map do |format|
    <<~ROW
      | #{format_input(format, klass)}
    ROW
  end.join("")
end

def format_input(format, klass)
  klass.input(format).flatten.map do |s|
    if [:latex, :unicodemath].include?(format)
      "`\\#{s}`"
    else
      "`#{s}`"
    end
  end.join(", ").gsub(/\|/, "\\|")
end

task :default => :spec
