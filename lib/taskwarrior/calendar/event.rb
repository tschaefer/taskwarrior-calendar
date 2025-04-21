# frozen_string_literal: true

require 'icalendar'
require 'icalendar/tzinfo'

class Taskwarrior
  class Calendar
    module Event
      def add_event(event, task, type, alarm)
        date = Icalendar::Values::DateTime.new(
          tz_info.utc_to_local(DateTime.parse(task[type])),
          'tzid' => tz_name
        )
        event.dtstart = event.dtend = date

        event.summary = "#{type.capitalize}: #{task['description']}"
        event.ip_class = 'PRIVATE'
        event.uid = task['uuid']

        add_event_alarm(event, task, type) if alarm
      end

      private

      def add_event_alarm(event, task, type)
        event.alarm do |a|
          a.action = 'DISPLAY'
          a.summary = "#{type.capitalize}: #{task['description']}"
          a.trigger = '-PT15M'
        end
      end
    end
  end
end
