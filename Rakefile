begin
  require "rubygems"
    require "jeweler"

  namespace :jeweler do

    Jeweler::Tasks.new do |gem|
      gem.name        = "oughtve"

      gem.version     = `git log --pretty=oneline | wc -l`.chomp


      gem.summary     = "Command-line tool for notes associated by filesystem location."
      gem.description = "Command-line tool for notes associated by filesystem location."
      gem.email       = "oughtve@projects.kittensoft.org"
      gem.homepage    = "http://github.com/rue/oughtve"
      gem.authors     = ["Eero Saynatkari"]

      gem.add_runtime_dependency      "dm-core",      ">= 0.10.2"
      gem.add_runtime_dependency      "data_objects", ">= 0.10.1"
      gem.add_runtime_dependency      "do_sqlite3",   ">= 0.10.1"

      gem.add_development_dependency  "rspec",        ">= 1.3.0"

      gem.post_install_message = <<-END

      =======================================

      Oughtve has been installed. Please run

          $ oughtve --bootstrap

      to set up your database if you have not
      used Oughtve before.

      =======================================

      END
    end

    Jeweler::GemcutterTasks.new

  end

rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end


# Main tasks

desc "Generate Gem and push it."
task :release_gem => %w[jeweler:gemcutter:release]


