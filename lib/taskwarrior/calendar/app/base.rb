# frozen_string_literal: true

require 'clamp'
require 'pastel'
require 'tty-pager'

require_relative '../version'
require_relative '../../calendar'

class Taskwarrior
  class Calendar
    module App
      class BaseCommand < Clamp::Command
        option ['-m', '--man'], :flag, 'show manpage' do
          manpage = <<~MANPAGE
            Name:
              task-ical - Taskwarrior tasks to ical converter

            #{help}
            Description:
              The due timestamp, optionally scheduled timestamp and
              description of a task are used to create a calendar event.

            Authors:
                Tobias Schäfer <github@blackox.org>

            Copyright and License
                This software is copyright (c) 2022 by Tobias Schäfer.

                This package is free software; you can redistribute it and/or
                modify it under the terms of the "MIT License".
          MANPAGE
          TTY::Pager.page(manpage)

          exit 0
        end

        option ['-v', '--version'], :flag, 'show version' do
          puts "task-ical #{Taskwarrior::Calendar::VERSION}"
          exit 0
        end

        def bailout(message)
          puts Pastel.new.red.bold(message)
          exit 1
        end
      end
    end
  end
end
