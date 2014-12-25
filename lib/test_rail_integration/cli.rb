require 'thor'
require_relative 'generator/project'

module TestRailIntegration
  class CLI < Thor
    desc "perform", "Creates project for interaction with TestRail"

    def perform
      TestRailIntegration::TestTail::Generators::Project.copy_file("run_test_run.rb")
    end
  end
end