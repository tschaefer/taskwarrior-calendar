# frozen_string_literal: true

require 'date'
require 'icalendar'
require 'icalendar/tzinfo'
require 'json'
require 'open3'

require_relative 'calendar/timezone'
require_relative 'calendar/event'

class Taskwarrior
  ##
  # Convert taskwarrior tasks to calendar events.
  #
  #     calendar = Taskwarrior::Calendar.new(filter: 'status:pending', alarm: false)
  #     calendar.publish(filename: '~/tasks.ics')
  #
  # Task *due* and optional *scheduled* dates if available are exported as
  # calendar events.
  #
  # By default tasks are filtered by +status:pending+ and all events are
  # appointed with an alarm *15* *minutes* *before* the event date. This can be
  # configured with the filter and alarm options. For further filter details see
  # https://taskwarrior.org/docs/filter. All events are exported in the
  # timezone of the system. This can be configured with the +TZ+ environment
  # variable.
  class Calendar
    include Timezone
    include Event

    ##
    # Initialize a new taskwarrior calendar object. Tasks are filtered by
    # +status:pending+ and all calendar events are appointed with an alarm.
    # This can be configured with the +filter+ and +alarm+ options.
    #
    # On failure an error is raised.
    def initialize(filter: 'status:pending', alarm: true)
      tasks(filter:)
      calendar(alarm:)
    end

    ##
    # Return the Icalendar::Calendar object.
    def to_object
      @calendar
    end

    ##
    # Return the calendar as ICS string.
    def to_ical
      @calendar.to_ical
    end

    ##
    # Publish calendar ICS to a file, default +taskwarrior.ics+. This can be
    # configured with the +filename+ option.
    def publish(filename: 'taskwarrior.ics')
      File.write(filename, to_ical)
    end

    private

    def tasks(filter:)
      @tasks = Open3.popen3("task #{filter} export") do |_, stdout, stderr, process|
        raise IOError, "taskwarrior: #{stderr.read}" if process.value.exitstatus != 0

        JSON.parse(stdout.read)
      end
    end

    def calendar(alarm:)
      @calendar = Icalendar::Calendar.new
      @calendar.add_timezone(tz_info.ical_timezone(DateTime.now))

      @tasks.each do |task|
        %w[due scheduled].each do |type|
          next if !task.key?(type) || task[type].empty?

          @calendar.event do |event|
            add_event(event, task, type, alarm)
          end
        end
      end
    end
  end
end
