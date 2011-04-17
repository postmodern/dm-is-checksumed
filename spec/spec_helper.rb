require 'rspec'
require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-is-checksumed'

DataMapper::Logger.new(STDERR, :debug) if ENV['DEBUG']
DataMapper::Spec.setup

RSpec.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
end
