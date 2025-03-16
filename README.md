# taskwarrior-calendar

Convert taskwarrior tasks to calendar events.

## Introduction

Export [taskwarrior](https://taskwarrior.org) tasks *due* and optional
*scheduled* dates if available as calendar events.
By default tasks are filtered by **status:pending** and all events are appointed
with an **alarm 15 minutes before** the event date.

## Installation

    gem install taskwarrior-calendar

## Usage

    task-ical convert --no-alarm

    task-ical --filter project:home --file home-tasks.ics

For further information about the command line tool `task-ical` use the
switches `--help` / `--man`.

## License

[MIT License](https://spdx.org/licenses/MIT.html)

## Is it any good?

[Yes.](https://news.ycombinator.com/item?id=3067434)
