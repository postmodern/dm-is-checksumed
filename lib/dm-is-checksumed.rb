require 'dm-core'
require 'dm-is-checksumed/is/checksumed'

DataMapper::Model.append_extensions DataMapper::Is::Checksumed
