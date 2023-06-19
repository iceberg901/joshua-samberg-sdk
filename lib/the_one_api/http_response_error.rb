# frozen_string_literal: true

module TheOneApi
  # Our own error class to throw for HTTP response errors
  #
  # Good encapsulation to not expose our consumers to the
  # error types of the underlying libraries unintentionally
  class HttpResponseError < TheOneApi::Error
    attr_reader :status

    def initialize(status, msg = nil)
      @status = status
      super(msg)
    end
  end
end
