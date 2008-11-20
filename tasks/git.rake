namespace :git do

  # A prerequisites task that all other tasks depend upon
  task :prereqs

  desc 'Show tags from the Git repository'
  task :show_tags => 'git:prereqs' do |t|
    system "git tag"
  end

  desc 'Create a new tag in the Git repository'
  task :create_tag => 'git:prereqs' do |t|
    abort "No version set!" unless Proj.version

    tag = "#{PROJ.name}-#{PROJ.version}"
    msg = "Tagged #{PROJ.name} version #{PROJ.version}."

    puts "Creating Git tag '#{tag}'"

    # Git already checks that the tag does not exist
    abort "Unable to create git tag!" unless system "git tag -a -m '#{msg}' #{tag}"

    if `git remote`.chomp == "origin"
      unless system "git push origin #{tag}"
        abort "Could not push tag to remote Git repository!"
      end
    end
  end

end  # namespace :git

task 'gem:release' => 'git:create_tag'

