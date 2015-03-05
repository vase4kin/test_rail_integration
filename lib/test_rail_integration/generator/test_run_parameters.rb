require_relative 'API_client'

module TestRail
  class TestRunParameters
    VENTURE_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:ventures]
    ENVIRONMENT_REGEX ||= TestRail::TestRailDataLoad.test_rail_data[:environments]
    CHECK_TEST_RUN_NAME ||= TestRail::TestRailDataLoad.test_rail_data[:check_test_run_name]
    EXEC_COMMAND ||= TestRail::TestRailDataLoad.test_rail_data[:exec_command]

    attr_accessor :environment, :venture, :command

    #
    # Checking of correct naming of created test run and return parameters for running test run
    #
    def initialize(env=nil)
      @venture = ""
      @environment = ""
      if env
        if env[0]
          @venture = env[0] if env[0].match(/(#{VENTURE_REGEX})/)
        end
        if env[1]
          @environment = env[1] if env[1].match(/(#{ENVIRONMENT_REGEX})/)
        end
      end
      @command = EXEC_COMMAND
    end
  end
end