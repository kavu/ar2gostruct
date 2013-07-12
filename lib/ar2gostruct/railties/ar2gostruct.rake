desc 'Convert ActiveRecord Models to Go Structs'
task :ar2gostruct do
  Ar2gostruct::Converter.convert!
end
