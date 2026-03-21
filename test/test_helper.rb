ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def with_env(overrides)
      original = {}

      overrides.each do |key, value|
        original[key] = ENV[key]
        if value.nil?
          ENV.delete(key)
        else
          ENV[key] = value
        end
      end

      yield
    ensure
      original.each do |key, value|
        if value.nil?
          ENV.delete(key)
        else
          ENV[key] = value
        end
      end
    end
  end
end
