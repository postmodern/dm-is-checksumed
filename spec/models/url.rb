require 'dm-core'
require 'dm-is-checksumed'

class Url

  include DataMapper::Resource

  is :checksumed

  property :id, Serial

  property :url, Text, :required => true

  checksum :url

end
