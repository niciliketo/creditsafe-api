# frozen_string_literal: true

require 'faraday'
require 'json'
module Creditsafe
  module Api
    ##
    # Client connects to the creditsafe api and provides methods
    # matching API calls.
    class Client
      include Creditsafe::Api::Utils
      def initialize(params)
        check_params(params)

        @username = params[:username]
        @password = params[:password]
        @loglevel = params[:loglevel] || Logger::WARN

        @environment = params[:environment] || :production
        # Proxy either makes real calls or dummy calls...
        if @environment == :dummy
          @proxy = DummyClient.new(params)
        else
          @proxy = RealClient.new(params)
        end
      end

      def connect
        @proxy.connect
        @token = @proxy.token
        true
      end

      def connected?
        @proxy.connected?
      end

      def company_search(params)
        @proxy.company_search(params)
      end

      def company_credit_report(connect_id)
        @proxy.company_credit_report(connect_id)
      end

      private

      def check_params(params)
        missing = MANDATORY_PARAMS.find_all{ |p| params[p].nil? }
        unexpected = params.reject { |k| EXPECTED_PARAMS.include?(k) }
        raise(IncorrectParams, "Missing params: #{missing}") unless missing.empty?
        raise(IncorrectParams, "Unexpected params: #{unexpected}") unless unexpected.empty?
      end

      def auth_header
        { 'Authorization' => @token }
      end

      def check_connected
        raise NotConnected if @token.nil?
      end

      # Stubbing responses is helpful for testing and also so we dont use up API credits
      # While testing, developing etc.
      def stub_responses
        Creditsafe::Api::DummyResponse.new
      end
    end
  end
end
