# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)
require 'taskwarrior/calendar/version'

Gem::Specification.new do |spec|
  spec.name        = 'taskwarrior-calendar'
  spec.version     = Taskwarrior::Calendar::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Tobias Schäfer']
  spec.email       = ['github@blackox.org']

  spec.summary     = 'Convert taskwarrior tasks to calendar events.'
  spec.description = <<~DESC
    #{spec.summary}

    The due timestamp, optionally scheduled timestamp and description of a
    task are used to create a calendar event.
  DESC
  spec.homepage    = 'https://github.com/tschaefer/taskwarrior-calendar'
  spec.license     = 'MIT'

  spec.files                 = Dir['lib/**/*']
  spec.bindir                = 'bin'
  spec.executables           = ['task-ical']
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 3.1.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri']       = 'https://github.com/tschaefer/taskwarrior-calendar'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/tschaefer/taskwarrior-calendar/issues'

  spec.post_install_message = 'All your tasks are belong to us!'

  spec.add_dependency 'base64'
  spec.add_dependency 'clamp', '~> 1.3.2'
  spec.add_dependency 'icalendar', '~> 2.9.0'
  spec.add_dependency 'logger'
  spec.add_dependency 'ostruct'
  spec.add_dependency 'pastel', '~> 0.8.0'
  spec.add_dependency 'tty-pager', '~> 0.14.0'
  spec.add_dependency 'tzinfo', '~> 2.0.6'
  spec.add_dependency 'tzinfo-data', '~> 1.2023.3'
end
