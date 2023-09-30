# frozen_string_literal: true

# Joel Test
class JoelTest
  include InMemoryHashCollection

  HASH = {
    source_control: 'Do you use source control?',
    one_step_builds: 'Can you make a build in one step?',
    daily_builds: 'Do you make daily builds?',
    bug_database: 'Do you have a bug database?',
    bugs_prioritized: 'Do you fix bugs before writing new code?',
    updated_schedule: 'Do you have an up-to-date schedule?',
    specs: 'Do you have a spec?',
    quiet_working_conditions: 'Do programmers have quiet working conditions?',
    best_tools: 'Do you use the best tools money can buy?',
    testers: 'Do you have testers?',
    code_screening: 'Do new candidates write code during their interview?',
    hallway_usability: 'Do you do hallway usability testing?'
  }.stringify_keys.freeze
end
