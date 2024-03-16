# frozen_string_literal: true

module EasyThrottle
  class Error < StandardError
    def initialize(msg: 'Rate limit exceeded', error: nil)
      super
    end
  end
end
