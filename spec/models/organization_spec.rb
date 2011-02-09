require 'spec_helper'

describe Organization do
  describe "unsaved" do
    subject { Factory.build(:organization) }
    
    it "should be valid" do
      subject.should be_valid
    end
    
    it "should be invalid when missing name" do
      Factory.build(:organization, { :name => nil }).should_not be_valid
    end
  end
end
