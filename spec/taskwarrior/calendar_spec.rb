# frozen_string_literal: true

require 'spec_helper'

require 'tempfile'

require 'taskwarrior/calendar'

RSpec.describe Taskwarrior::Calendar, :aggregate_failures do
  around do |example|
    ENV['TASKRC'] = File.expand_path('../fixtures/taskrc', __dir__)
    ENV['TASKDATA'] = File.expand_path('../fixtures/task', __dir__)
    example.run
    %w[TASKRC TASKDATA TZ].each { |key| ENV.delete(key) }
  end

  describe '#initialize' do
    it 'raises error on invalid timezone' do
      ENV['TZ'] = 'Europe/Unknown'

      expect { described_class.new }.to raise_error(TZInfo::InvalidTimezoneIdentifier)
    end

    it 'raises error on invalid task configuration' do
      %w[TASKRC TASKDATA].each { |key| ENV[key] = '/dev/null' } # rubocop:disable Style/FileNull

      expect { described_class.new }.to raise_error(IOError)
    end

    it 'returns a Taskwarrior::Calendar object on valid setup' do
      expect(described_class.new).to be_a(described_class)
    end
  end

  describe '#to_object' do
    let(:calendar) { described_class.new.to_object }

    it 'returns an Icalendar::Calendar object' do
      expect(calendar).to be_a(Icalendar::Calendar)
      expect(calendar.has_event?).to be true
      expect(calendar.has_timezone?).to be true
      expect(calendar.events.size).to eq(2)
      expect(calendar.events.first.has_alarm?).to be true
    end
  end

  describe '#to_ical' do
    let(:tasks) { described_class.new }
    let(:ical) { tasks.to_ical }
    let(:timezone) { tasks.tz_name }
    let(:uuid) { tasks.instance_variable_get(:@tasks).first['uuid'] }

    it 'returns an ICS String' do
      expect(ical).to be_a(String)
      expect(ical).to start_with("BEGIN:VCALENDAR\r\n")
      expect(ical).to include("TZID:#{timezone}\r\n")
      expect(ical).to end_with("END:VCALENDAR\r\n")
      expect(ical).to include("SUMMARY:Due: Call insurance.\r\n")
      expect(ical).to include("SUMMARY:Scheduled: Call insurance.\r\n")
      expect(ical).to include("UID:#{uuid}\r\n")
    end
  end

  describe '#publish' do
    let(:tasks) { described_class.new }

    it 'writes an ICS file' do
      Tempfile.create('tasks.ics') do |file|
        tasks.publish(filename: file.path)

        expect(File.exist?(file.path)).to be true
        expect(file.read).to match(tasks.to_ical)
      end
    end
  end
end
