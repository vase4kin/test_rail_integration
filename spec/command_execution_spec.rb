require 'spec_helper'
require_relative '../lib/test_rail_integration/generator/project/test_run'

describe 'Command execution' do

  before(:each) do
    allow(TestRail::Connection).to receive(:get_test_runs).and_return([{'name' => 'test run name', 'id' => '4555'}])
    allow(TestRail::Connection).to receive(:generate_test_run_name).and_return('test run name')
    allow(TestRail::Connection).to receive(:create_new_test_run_with_name).and_return([{'name' => 'test run name'}])
    allow(TestRail::Connection).to receive(:cases_id).and_return(%w(456 678))
  end

  it 'test that user can create test run with command for auto builds' do
    params = %w(auto id staging)
    TestRail::TestRun.create(params)
    expect(YAML.load(File.open(TestRail::TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH))[:test_run_id]).to eq(4555)
    expect(TestRail::Connection.test_run_id).to eq('4555')
    expect(File.read('cucumber_run.sh')).to eq("#!/bin/sh\ncucumber -p lazada.id.staging TESTRAIL=1 --color -f json -o cucumber.json -t  @C456,@C678")
  end

  it 'test that user can create test run with command for single build' do
    allow(TestRail::Connection).to receive(:test_run_name).and_return('DT VN staging test name')
    params = %w(4555)
    TestRail::TestRun.create(params)
    expect(YAML.load(File.open(TestRail::TestRailDataLoad::TEST_RAIL_FILE_CONFIG_PATH))[:test_run_id]).to eq(4555)
    expect(TestRail::Connection.test_run_id).to eq(4555)
    expect(File.read('cucumber_run.sh')).to eq("#!/bin/sh\ncucumber -p lazada.vn.staging TESTRAIL=1 --color -f json -o cucumber.json -t  @C456,@C678")
  end

  it 'test that user will see an exception if there is no config file' do
    allow(TestRailIntegration::TestRail::Generators::Project).to receive(:test_rail_data_file_exist?).and_return(false)
    params = %w(4555)
    expect { TestRail::TestRun.create(params) }.to raise_error(RuntimeError, "Please fill all required data in test rail data yml file")
  end

  it 'test that user will see copied config if there is no config file' do
    pending "implement this"
  end

  it 'test that user will see an exception if he try to run command with no params' do
    pending "implement this"
  end

  it 'test that user will see an exception if he try to run test run with incorrect name' do
    pending "implement this"
  end

end