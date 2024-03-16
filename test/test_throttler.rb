# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/throttler'

class ThrottlerTest < Minitest::Test
  def setup
    @endpoint = 'getItemOffers'
    @prefix = 'US'
    @redis = Minitest::Mock.new
    @options = Throttler::DEFAULT_OPTIONS
    @burst_key = "#{@prefix}:#{@endpoint}:burst"
    @subject = Throttler.new(@endpoint, @prefix, @options)
  end

  def test_initialize
    assert_equal @endpoint, @subject.instance_variable_get(:@endpoint)
    assert_equal @prefix, @subject.instance_variable_get(:@prefix)
    assert_equal @options, @subject.instance_variable_get(:@options)
  end

  def test_with_throttling
    block = proc { 'result' }
    @redis.expect(:pttl, 0)
    @redis.expect(:psetex, true)
    assert_equal 'result', @subject.with_throttling(&block)
  end

  def test_with_throttling_when_api_error_with_code_429_occurs
    block = proc { raise StandardError.new(code: 429) }
    assert_raises(StandardError) { @subject.with_throttling(&block) }
    assert_mock @redis
  end

  def test_with_throttling_when_api_error_with_code_500_occurs
    block = proc { raise StandardError.new(code: 500) }
    assert_raises(StandardError) { @subject.with_throttling(&block) }
    assert_mock @redis
  end
end
