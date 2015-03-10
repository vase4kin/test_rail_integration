require 'thor'
require 'generator/project'
require 'generator/project/test_run'

module TestRailIntegration
  class CLI < Thor

    desc "prepare", "Creates project for interaction with TestRail"
    def prepare
      TestRailIntegration::TestRail::Generators::Project.copy_file("test_rail_data.yml", "config/data/")
    end

    desc "create", "Create test run and executable file"
    option :args
    def create
      TestRail::TestRun.create(args)
    end

  end
end