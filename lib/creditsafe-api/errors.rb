# frozen_string_literal: true

##
# Outer namespace to Creditsafe::API
module Creditsafe
  ##
  # Inner namespace to Creditsafe::API
  module Api
    ##
    # Error class for API connection issues
    class NotConnected < StandardError
      def initialize(msg = 'Please connect before making a request')
        super
      end
    end

    # Error class for incorrect params
    class IncorrectParams < StandardError
      def initialize(msg = 'The provided params were incorrect')
        super
      end
    end
  end
end
