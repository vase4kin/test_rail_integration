require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX     ||= TestRail::TestRailDataLoad.test_rail_data[:ventures]
    ENVIRONMENT_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:environments]

    attr_accessor :environment, :venture

    #
    # Checking of correct naming of created test run and return parameters for runnng test run
    #
    def initialize
      parameters = Connection.test_run_name.downcase.match(/(#{VENTURE_REGEX}) (#{ENVIRONMENT_REGEX})*/)
      begin
        @venture     = parameters[1]
        @environment = parameters[2]
      rescue Exception
        raise ("The test run name is not valid. Format: 'venture env description'")
      end
    end
  end
end