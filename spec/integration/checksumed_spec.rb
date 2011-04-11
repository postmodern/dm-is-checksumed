require 'spec_helper'
require 'models/url'

describe DataMapper::Is::Checksumed do
  subject { Url }

  before(:all) { subject.auto_migrate! }

  let(:url) { 'http://AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' }
  let(:url_checksum) { '7aea54fe73fda6bca28f47ea57f1af1a6bc7b28ef323a3b85763131baad46e8e' }

  it "should calculate the checksums of properties" do
    resource = subject.new(:url => url)

    resource.url_checksum.should == url_checksum
  end

  context "queries" do
    before(:all) do
      subject.create(:url => 'http://foo/')
      subject.create(:url => url)
      subject.create(:url => 'http://bar/')
    end

    it "should find the first resource with a matching checksum" do
      resource = subject.first(:url => url)

      resource.url_checksum.should == url_checksum
      resource.url.should == url
    end

    it "should find all resources with a matching checksum" do
      resources = subject.all(:url => url)

      resources.length.should == 1
      resources[0].url_checksum.should == url_checksum
      resources[0].url.should == url
    end
  end
end
