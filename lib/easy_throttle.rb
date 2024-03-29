# frozen_string_literal: true

require 'redis'

class EasyThrottle
  DEFAULT_OPTIONS = { interval: 60, limit: 1, burst: 20 }.freeze

  def self.with_throttling(endpoint, prefix, options = DEFAULT_OPTIONS, &block)
    new(endpoint, prefix, options).with_throttling { block.call }
  end

  def initialize(endpoint, prefix, options = DEFAULT_OPTIONS)
    @endpoint = endpoint
    @prefix = prefix
    @redis = Redis.new
    @options = EasyThrottle.configuration.limits.fetch(endpoint, options)
  end

  def with_throttling(&block)
    retry_count ||= 0
    result = nil
    loop do
      if pool
        result = block.call

        break
      else
        sleep 0.1
      end
    end
    result
  rescue EasyThrottle.configuration.errors => e
    if e.code == 429
      extend_key_duration
      retry
    end

    if e.code == 500
      raise if (retry_count += 1) > 5
      extend_key_duration
      retry
    end

    raise EasyThrottle::Error.new(msg: e.message, error: e)
  end

  def pool
    max_ttl = (options[:burst] - 1) * options[:interval] * 1000
    burst_ttl = redis.pttl(burst_key)
    burst_ttl = 0 if burst_ttl.negative?

    if burst_ttl <= max_ttl
      redis.psetex(burst_key, burst_ttl + options[:interval] * 1000, true)
    end
  end

  private

  attr_reader :redis, :endpoint, :prefix, :options

  def burst_key
    "#{prefix}:#{endpoint}:burst"
  end

  def extend_key_duration
    redis.psetex(burst_key, (options[:interval] + 1) * options[:burst] * 1000, true)
  end
end
