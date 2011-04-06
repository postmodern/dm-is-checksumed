require 'spec_helper'
require 'models/url'

describe DataMapper::Is::Checksumed do
  before(:all) { Url.auto_migrate! }
end
