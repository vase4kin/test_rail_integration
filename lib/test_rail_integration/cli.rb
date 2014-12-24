require 'thor'
require_relative 'generator/project'

module TestRailIntegration
  class CLI < Thor
    desc "run", "Creates project for interaction with TestRail"
    def run
      TestRailIntegration::TestTail::Generators::Project.copy_run_test_run
    end
  end
end