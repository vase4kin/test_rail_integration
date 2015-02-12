require 'yaml'

module TestRail
  class TestRailDataLoad
    TEST_RAIL_FILE_CONFIG_PATH ||= ('config/data/test_rail_data.yml')

    #
    # Loading of test rail information
    #
    def self.test_rail_data
      YAML.load(File.open(TEST_RAIL_FILE_CONFIG_PATH))
    end
  end
end