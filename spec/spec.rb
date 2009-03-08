#!/usr/bin/env ruby -w

# The spec files are designed to be run one at a time
# because it removes the necessity of completely tearing
# down the DB bootstrap which is *exceedingly* difficult in
# any ORM.

require "fileutils"
require "tmpdir"

specdir = File.expand_path "#{File.dirname __FILE__}"
dummy_dir = File.join specdir, "/dummy_home_dir_#{$$}"

FileUtils.rm_r  dummy_dir, :secure => true  rescue nil


# Raw output?
raw = if ARGV.first == "--raw"
        ARGV.shift
        true
      end

# Split any files from options to pass to the spec program
split = ARGV.index "--"

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

  start = Time.now
  examples, fails = 0, 0

  files.each do |spec|
    FileUtils.mkdir dummy_dir

    puts "\n#{spec}:"

    if raw
      pid = fork {
        exec "spec", opts, File.expand_path(spec)
      }

      Process.waitpid pid
    else
      output = `spec #{opts} #{File.expand_path(spec)}`

      stats = output.scan(/(\d+) examples?, (\d+) failures?/).first
      examples += stats.first.to_i
      fails += stats.last.to_i

      puts output
    end

    FileUtils.rm_r  dummy_dir, :secure => true rescue nil
  end

  unless raw
    puts "\n\n========================\n"
    puts "     Totals: #{fails}/#{examples}\n"
    puts "     Time:   #{Time.now - start}s\n"
    puts
  end

ensure
  ENV['HOME'] = real_home
end

