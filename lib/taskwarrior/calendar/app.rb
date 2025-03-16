# frozen_string_literal: true

require_relative 'app/base'
require_relative 'app/convert'

class Taskwarrior
  class Calendar
    module App
      class Command < Taskwarrior::Calendar::App::BaseCommand
        self.default_subcommand = 'convert'

        subcommand 'convert', 'Convert tasks to events', Taskwarrior::Calendar::App::ConvertCommand
      end
    end
  end
end
