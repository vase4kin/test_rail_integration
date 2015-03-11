require 'spec_helper'
require_relative '../lib/test_rail_integration/generator/test_rail_hooks'
require_relative '../lib/test_rail_integration/generator/test_case_result'

describe 'Update test results' do

  before(:each) do
    allow(TestRail::Connection).to receive(:commit_test_result).and_return('good!')
    @scenario = double('scenario')
    allow(@scenario).to receive(:source_tag_names).and_return(['@C4556'])
    allow(@scenario).to receive(:title).and_return('title')
    allow(TestRail::Connection).to receive(:change_test_run_name).and_return('changed!')
  end

  it 'test that test rail data is correct if there is no previous result and current is passed ( -> P )' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    allow(@scenario).to receive(:passed?).and_return(true)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
  end

  it 'test that test rail data is correct if there is no previous result and current is failed ( -> F )' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return([])
    allow(@scenario).to receive(:passed?).and_return(false)
    steps = double('steps')
    allow(steps).to receive(:exception).and_return('exception')
    allow(@scenario).to receive(:steps).and_return(steps)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n "})
  end

  it 'test that test rail data is correct if previous result is passed and current is passed (P -> P)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 1, "comment" =>"test **passed:**"}])
    allow(@scenario).to receive(:passed?).and_return(true)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>1, :comment => 'test **passed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 1, :comment => "test **passed:** \"title\""})
  end

  it 'test that test rail data is correct if previous result is passed and current is failed (P -> F)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 1, "comment" =>"test **passed:**"}])
    allow(@scenario).to receive(:passed?).and_return(false)
    steps = double('steps')
    allow(steps).to receive(:exception).and_return('exception')
    allow(@scenario).to receive(:steps).and_return(steps)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n "})
  end

  it 'test that test rail data is correct if previous result is failed and current is failed (F -> F)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 5, "comment" =>"test **failed:**"}])
    allow(@scenario).to receive(:passed?).and_return(false)
    steps = double('steps')
    allow(steps).to receive(:exception).and_return('exception')
    allow(@scenario).to receive(:steps).and_return(steps)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n test **failed:**"})
  end

  it 'test that test rail data is correct if previous result is failed and current is passed (F -> P)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 5, "comment" =>"test **failed:**"}])
    allow(@scenario).to receive(:passed?).and_return(true)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>0, :comment => 'test **passed:**'})
    expect(test_result.to_test_rail_api).to eq({:comment => "test **passed:** \"title\"\n test **failed:**"})
  end

  it 'test that test rail data is correct if previous result is comment and current is passed (C -> P)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 5, "comment" =>"test **failed:**"}])
    # there must be failed previous results for comment
    allow(@scenario).to receive(:passed?).and_return(true)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>0, :comment => 'test **passed:**'})
    expect(test_result.to_test_rail_api).to eq({:comment => "test **passed:** \"title\"\n test **failed:**"})
  end

  it 'test that test rail data is correct if previous result is comment and current is failed (C -> F)' do
    allow(TestRail::Connection).to receive(:get_test_results).and_return(
                                       [{"status_id" => 5, "comment" =>"test **failed:**"}])
    # there must be failed previous results for comment
    allow(@scenario).to receive(:passed?).and_return(false)
    steps = double('steps')
    allow(steps).to receive(:exception).and_return('exception')
    allow(@scenario).to receive(:steps).and_return(steps)
    test_result = TestRail::Hook.update_test_rail(@scenario)
    expect(test_result.test_case_id).to eq('4556')
    expect(test_result.title).to eq('title')
    expect(test_result.comment).to eq({:status=>5, :comment => 'test **failed:**'})
    expect(test_result.to_test_rail_api).to eq({:status_id => 5, :comment => "test **failed:** \"title\"\n Exception : exception\n test **failed:**"})
  end

  after(:each) do
    allow(TestRail::Connection).to receive(:get_test_results).and_call_original
  end

end