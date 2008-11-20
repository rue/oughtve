#!/usr/bin/env ruby -w

# The spec files are designed to be run one at a time
# because it removes the necessity of completely tearing
# down the DB setup which is *exceedingly* difficult in
# any ORM.

require "fileutils"
require "tmpdir"

specdir = File.expand_path "#{File.dirname __FILE__}"
dummy_dir = File.join specdir, "/dummy_home_dir_#{$$}"

FileUtils.rm_r  dummy_dir, :secure => true  rescue nil


# Split any files from options to pass to the spec program
split = ARGV.index('--')

opts  = if split
          ARGV.slice!((split + 1)..-1).join ' '
        else
          '-f s'
        end

files = if ARGV.empty?
          Dir.glob "#{specdir}/*_spec.rb"
        else
          ARGV.pop if split
          ARGV.map {|f| "#{specdir}/#{File.basename(f)}" }
        end

begin
  real_home = ENV['HOME']
  ENV['HOME'] = dummy_dir

  files.each do |spec|
    FileUtils.mkdir dummy_dir

    pid = fork {
      puts "\n#{spec}:"

      exec "spec", opts, File.expand_path(spec)
    }

    Process.waitpid pid
    FileUtils.rm_r  dummy_dir, :secure => true rescue nil
  end

ensure
  ENV['HOME'] = real_home
end

