require 'fileutils'
require 'thor/group'

module TestRailIntegration
  module TestTail
    module Generators
      class Project < Thor::Group
        include Thor::Actions

        desc "Generates files that contains information about TestRail"

        def self.source_root
          File.dirname(__FILE__) + "/project"
        end

        def self.project_root
          File.dirname(__FILE__)
        end

        def self.test_rail_data_file_exist?
          File.exists?("#{project_root}/config/data/testrail_data.yml")
        end

        def self.copy_test_rail_data_yml
          FileUtils.cp("project/testrail_data.yml", "#{project_root}/config/data/testrail_data.yml")
        end

        def self.copy_run_test_run
          FileUtils.cp("#{project_root}/project/run_test_run.rb", "run_test_run.rb")
        end
      end
    end
  end
end


