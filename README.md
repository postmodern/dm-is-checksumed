# dm-is-checksumed

* [Homepage](http://github.com/postmodern/dm-is-checksumed)
* [Documentation](http://rubydoc.info/gems/dm-is-checksumed/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Adds checksum properties to a Model, associated with another property.

## Features

* Uses sha256
* Allows unique and non-unique checksums.

## Examples

    require 'dm-is-checksumed'

    class Url

      include DataMapper::Resource

      is :checksumed

      property :id, Serial

      property :url, Text

      checksum_property :url

    end

    url = Url.create(:url => 'http://example.com/extremely/long/url....')
    url.url_checksum
    # => "b74d7288b86817dea55bd044d3cedc013e83518b461cd6f202be85e33d95715b"

    url = Url.first_or_create(:url => 'http://example.com/same/huge/url')
    url.url_checksum
    # => "b74d7288b86817dea55bd044d3cedc013e83518b461cd6f202be85e33d95715b"

    url = Url.first_or_create(:url => 'http://example.com/different/url')
    url.url_checksum
    # => "09a27797a33153b005871b61675a920fa6bedbb034a3b283bbe5803a1d31ac42"

## Requirements

* [dm-core](http://github.com/datamapper/dm-core) ~> 1.0

## Install

    $ gem install dm-is-checksumed

## Copyright

Copyright (c) 2011 Hal Brodigan

See {file:LICENSE.txt} for details.
