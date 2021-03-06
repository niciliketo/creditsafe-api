require 'minitest/autorun'
require 'creditsafe-api'
require 'vcr'
module Creditsafe
  class ApiTest < Minitest::Test
    VCR.configure do |config|
      config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
      config.hook_into :webmock
    end

    def test_dummy_initialize_success
      client = Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environment: :dummy)
      assert_equal %i[@username @password @loglevel @environment @proxy],
                   client.instance_variables
    end

    def test_dummy_initialize_wrong_param
      assert_raises Creditsafe::Api::IncorrectParams do
        Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environmen: :dummy)
      end
    end

    def test_dummy_initialize_missing_param
      assert_raises Creditsafe::Api::IncorrectParams do
        Creditsafe::Api::Client.new(username: 'foo')
      end
    end

    def test_dummy_authenticate_response
      client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :dummy)
      client.connect
      assert client.connected?
    end

    def test_dummy_company_search_response
      client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :dummy)
      client.connect
      result = client.company_search(countries: 'GB', name: 'market')
      assert_equal '2d054750-161f-11eb-816b-020efb2a7f15', result['correlationId'], 'Incorrect id returned'
    end

    def test_dummy_company_credit_report_response
      client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :dummy)
      client.connect
      result = client.company_credit_report('GB-0-07332766')
      assert_equal 'MARKET DOJO LTD', result['report']['companySummary']['businessName']
    end

    def test_dummy_can_assign_log_level
      Creditsafe::Api.logger.level = Logger::FATAL
      assert_equal 4, Creditsafe::Api.logger.level
    end
  end
end
