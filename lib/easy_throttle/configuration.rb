# frozen_string_literal: true

module EasyThrottle
  class Configuration
    attr_accessor :interval, :limit, :burst, :errors, :limits

    def initialize
      @interval = 60
      @limit = 1
      @burst = 20
      @errors = [AmzSpApi::ApiError]
      @limits = {}
    end

    def add_error(error)
      @errors << error
    end

    # Options example: { interval: 10, limit: 1, burst: 1 }
    def add_limit(endpoint, options = {})
      @limits[endpoint] = options
    end
  end
end
