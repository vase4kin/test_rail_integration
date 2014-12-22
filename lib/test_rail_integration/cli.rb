require 'thor'
require 'test_rail_integration/generators/project'

module TestRailIntgration
  class CLI < Thor
    desc "create", "Creates project for interaction with TestRail"
    def create
      TestGen::Generators::Project.start
    end
  end
end