require 'fileutils'
require 'thor/group'

module TestRailIntegration
  module TestRail
    module Generators
      class Project < Thor::Group
        include Thor::Actions

        desc "Generates files that contains information about TestRail"

        #
        # Obtaining path of project folder
        #
        def self.source_root
          File.dirname(__FILE__)
        end

        #
        # Checking existence of tes trail data file
        #
        def self.test_rail_data_file_exist?
          File.exists?("config/data/test_rail_data.yml")
        end

        #
        # Copying templates for using for accessing to testrail
        #
        def self.copy_file(file_name, root = nil)
          if file_name == "test_rail_data.yml"
            FileUtils.mkdir_p("config/data")
          end
          if root
            FileUtils.cp("#{source_root}/project/#{file_name}", "#{root}/#{file_name}")
          else
            FileUtils.cp("#{source_root}/project/#{file_name}", "#{file_name}")
          end
        end
      end
    end
  end
end