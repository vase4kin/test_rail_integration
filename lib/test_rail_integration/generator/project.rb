require 'fileutils'
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

        def self.test_rail_data_file_exist?
          File.exists?("config/data/test_rail_data.yml")
        end

        def self.copy_file(file_name, root = nil)
          FileUtils.cp("#{source_root}/project/#{file_name}", "#{root}/#{file_name}")
        end
      end
    end
  end
end


