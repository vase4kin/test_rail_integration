require "testrail_integration/version"
require 'ftools'
require 'thor/group'

module TestRailIntegration
  module TestTail
    module Generators
      class Project < Thor::Group
        include Thor::Actions

        desc "Generates files that contains information about TestRail"

        def self.source_root
          File.dirname(__FILE__)
        end

        def self.project_root
          File.dirname(__FILE__) + "/project"
        end

        def self.file_exist?
          exists?("#{project_root}/config/data/testrail_data.yml")
        end

        def copy_testrail_data_yml
          copy("project/testrail_data.yml", "#{project_root}/config/data/testrail_data.yml")
        end

        def copy_run_test_run
          copy("project/run_test_run.rb", "#{project_root}/config/data/testrail_data.yml")
        end
        TestGen::Generators::Project.start(copy_run_test_run)
      end
    end
  end
end


