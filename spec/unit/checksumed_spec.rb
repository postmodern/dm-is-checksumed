require 'spec_helper'
require 'models/url'

describe DataMapper::Is::Checksumed do
  describe "Checksumed[]" do
    subject { DataMapper::Is::Checksumed }

    let(:expected) { '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824' }

    it "should calculate SHA256 checksums" do
      subject.checksum('hello').should == expected
    end

    it "should convert non-Strings to Strings" do
      subject.checksum(:hello).should == expected
    end
  end

  subject { Url }
  before(:all) { subject.auto_migrate! }

  it "should record which properties are checksumed" do
    subject.checksumed_properties.should include(:url)
  end

  it "should add accompanying checksum properties" do
    subject.properties.should be_named(:url_checksum)
  end

  it "should make the checksum properties unique by default" do
    subject.properties[:url_checksum].should be_unique
  end

  describe "checksum_query" do
    let(:url) { 'http://AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' }
    let(:url_checksum) { '7aea54fe73fda6bca28f47ea57f1af1a6bc7b28ef323a3b85763131baad46e8e' }

    it "should not modify Undefined queries" do
      subject.checksum_query(DataMapper::Undefined).should == DataMapper::Undefined
    end

    it "should replace checksumed properties with their checksums" do
      new_query = subject.checksum_query({:url => url})

      new_query.should_not have_key(:url)
      new_query[:url_checksum].should == url_checksum
    end

    it "should not replace un-checksumed properties" do
      new_query = subject.checksum_query({:id => 2, :url => url})

      new_query[:id].should == 2
    end
  end
end
