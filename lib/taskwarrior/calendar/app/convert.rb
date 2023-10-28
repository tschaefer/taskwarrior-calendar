# frozen_string_literal: true

require_relative 'base'

class Taskwarrior
  class Calendar
    module App
      class ConvertCommand < Taskwarrior::Calendar::App::BaseCommand
        option '--[no-]alarm', :flag, 'add alarm to event', default: true
        option '--filter', 'FILTER', 'tasks filter', default: 'status:pending'
        option '--filename', 'FILE', 'ics output file'

        def execute
          calendar = Taskwarrior::Calendar.new(filter:, alarm: alarm?)
          return calendar.publish(filename:) if !filename.nil?

          puts calendar.to_ical
        rescue StandardError => e
          bailout(e.cause || e.message)
        end
      end
    end
  end
end
