# frozen_string_literal: true

require 'tzinfo'

class Taskwarrior
  class Calendar
    module Timezone
      def tz_name
        @tz_name ||= ENV['TZ'] || begin
          File.read('/etc/timezone').strip
        rescue Errno::ENOENT
          'UTC'
        end
      end

      def tz_info
        @tz_info ||= TZInfo::Timezone.get(tz_name)
      end
    end
  end
end
