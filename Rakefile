begin
  require "rubygems"
    require "jeweler"
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end


Jeweler::Tasks.new do |gem|
  gem.name        = "oughtve"

  gem.version     = "#{`git log --pretty=oneline | wc -l`.chomp}.#{`git log -1 --pretty=oneline`[0...8]}"


  gem.summary     = "Command-line tool for notes associated by filesystem location."
  gem.description = "Command-line tool for notes associated by filesystem location."
  gem.email       = "projects@kittensoft.org"
  gem.homepage    = "http://github.com/rue/oughtve"
  gem.authors     = ["Eero Saynatkari"]

  gem.add_runtime_dependency      "dm-core",      ">= 0.10.2"
  gem.add_runtime_dependency      "data_objects", ">= 0.10.1"
  gem.add_runtime_dependency      "do_sqlite3",   ">= 0.10.1"

  gem.add_development_dependency  "rspec",        ">= 1.3.0"
end

Jeweler::GemcutterTasks.new

