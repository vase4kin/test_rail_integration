require 'thor'
require_relative 'generator/project'

module TestRailIntegration
  class CLI < Thor
    desc "create", "Creates project for interaction with TestRail"
    def create
      TestRailIntegration::TestTail::Generators::Project.start(copy_run_test_run)
    end
  end
end