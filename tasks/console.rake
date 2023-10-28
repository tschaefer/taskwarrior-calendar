# frozen_string_literal: true

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

def silent
  original_stdout = $stdout.clone
  original_stderr = $stderr.clone
  $stderr.reopen File.new(File::NULL, 'w')
  $stdout.reopen File.new(File::NULL, 'w')
  yield
ensure
  $stdout.reopen original_stdout
  $stderr.reopen original_stderr
end

def reload!(print: true)
  puts 'Reloading...' if print
  root_dir = File.expand_path(__dir__)
  reload_dirs = %w[lib]
  reload_dirs.each do |dir|
    Dir.glob("#{root_dir}/#{dir}/**/*.rb").each { |f| silent { load(f) } }
  end

  true
end

desc 'Start a console session with Taskwarrior::Calendar loaded'
task :console do
  require 'irb'
  require 'irb/completion'
  require 'taskwarrior/calendar'

  ARGV.clear

  IRB.start
end
