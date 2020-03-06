require 'rake/clean'

desc 'todos arquivos'
task :all

FileList['learning/**/*.tex'].each do |f|
  pdf_file = f.ext('.pdf')
  file pdf_file => f do |t|
    sh "latexmk -pdflatex=lualatex -f -pdf #{t.source}"
  end

  task :all => pdf_file
end

md = FileList['folhas/**/*.md'].exclude("*README.md").each do |f|
  pdf_file = f.ext('.pdf')
  tex_file = f.ext('.tex')
  json_file = f.ext('.json')

  if ENV['DEBUG']=='1'
    print "Em modo debug: #{f}\n"
    file tex_file => [f, 'folha-filter.lua', 'folha.yaml'] do |t|
      sh "pandoc -d folha -f markdown+smart -L folha-filter.lua #{t.source} -s -o #{t.name}"
    end
    file json_file => [f, 'folha-filter.lua', 'folha.yaml'] do |t|
      sh "pandoc -d folha -f markdown+smart -L folha-filter.lua #{t.source} -s -o #{t.name}"
    end

    task :folhas => json_file
    task :folhas => tex_file
  end
  file pdf_file => [f, 'folha-filter.lua', 'folha.yaml']  do |t|
    sh "pandoc -d folha -f markdown+smart -L folha-filter.lua #{t.source} -o #{t.name}"
  end
  task :folhas => pdf_file
end

desc 'geras as folhas'
task :folhas

desc 'geras as folhas'
task :learning


folhas = FileList['folhas/**/*.md'].exclude("*README.md").each do |f|
  task :folhas => f.ext('.pdf')
end



task :default => :all

CLEAN.include(FileList['folhas/**/*.pdf'], FileList['folhas/**/*.tex'], FileList['folhas/**/*.json'])
