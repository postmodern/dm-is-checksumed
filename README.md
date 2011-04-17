# dm-is-checksumed

* [Source](http://github.com/postmodern/dm-is-checksumed)
* [Issues](http://github.com/postmodern/dm-is-checksumed/issues)
* [Documentation](http://rubydoc.info/gems/dm-is-checksumed/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

A DataMapper plugin which adds checksum properties to a Model, referencing
other properties.

## Features

* Uses sha256
* Allows unique and non-unique checksums.
* Automatically substitutes in checksums in queries to avoid expensive
  queries.
* Works with `first_or_create` and `first_or_new`.

## Examples

    require 'dm-is-checksumed'

    class Url

      include DataMapper::Resource

      is :checksumed

      property :id, Serial

      # The property to be checksumed
      property :url, Text

      # Defines the `url_checksum` property, referencing `url`
      checksum :url

    end

    # Checksums are automatically calculated
    url = Url.create(:url => 'http://example.com/extremely/long/url....')
    url.url_checksum
    # => "b74d7288b86817dea55bd044d3cedc013e83518b461cd6f202be85e33d95715b"

    # Checksums are automatically substituted into queries
    url = Url.first(:url => 'http://example.com/same/huge/url')
    # ~ (0.000116) SELECT "id", "url_checksum" FROM "urls" WHERE "url_checksum" = 'b74d7288b86817dea55bd044d3cedc013e83518b461cd6f202be85e33d95715b' ORDER BY "id" LIMIT 1

    # Works with first_or_create and first_or_new
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
