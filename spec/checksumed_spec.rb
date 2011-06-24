require 'spec_helper'

describe DataMapper::Is::Checksumed do
  describe "[]" do
    let(:expected) { '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824' }

    it "should calculate SHA256 checksums" do
      subject.checksum('hello').should == expected
    end

    it "should convert non-Strings to Strings" do
      subject.checksum(:hello).should == expected
    end
  end
end
