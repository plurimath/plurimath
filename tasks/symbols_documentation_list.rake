task :parens_documentation_list do
  write_doc_file("./supported_parens_list.adoc", type: :paren)
end

task :symbols_documentation_list do
  write_doc_file("./supported_symbols_list.adoc", type: :symbols)
end

def write_doc_file(doc_file, type:)
  File.delete(doc_file) if File.exist?(doc_file)

  File.open(doc_file, "a") do |file|
    file.write(file_header)
    Plurimath::Utility.send(:"#{type}_files").each do |symbol|
      file_name = File.basename(symbol, ".rb")
      klass = Plurimath::Utility.get_symbol_class(file_name)
      next if klass::INPUT.empty?

      file.write(documentation_content(file_name, klass))
    end
    file.write("|===")
  end
end

def documentation_content(file_name, klass)
  <<~DOCUMENTATION
    | #{Plurimath::Utility.capitalize(file_name)}
    l|
    #{input(:asciimath, klass)}
    l|
    #{input(:latex, klass)}
    l|
    #{input(:mathml, klass)}
    l|
    #{input(:omml, klass)}
    l|
    #{input(:unicodemath, klass)}
    | `#{Plurimath::Utility.hexcode_in_input(klass) || klass.input(:asciimath).first}`\n
  DOCUMENTATION
end

def file_header
  <<~HEADER
    |===
    |  | AsciiMath | LaTeX | MathML | OMML | UnicodeMath | Presentation \n
  HEADER
end

def input(lang, klass)
  regex_exp = %r{^[A-Za-z]+\_*[a-zA-Z]+}
  arr = klass.input(lang).flatten
  arr.each { |str| str.insert(0, "\\\\") if str.match?(regex_exp) } if [:latex, :unicodemath].any?(lang)
  arr.join("\n").gsub(/\|/, "\\|")
end
