require 'spec_helper'

describe Distribution do
  # This spec passed under mongoid.2.0.0.beta.20 but did not pass under
  # mongoid.2.0.0.rc.5. More information on Mongoid's issue tracker:
  # http://github.com/mongoid/mongoid/issues/issue/552
  it "should not be saveable because it must be embedded" do
    lambda {
      Factory.create(:distribution)
    }.should raise_error(Mongoid::Errors::InvalidCollection)
  end

  it "should be valid" do
    Factory.build(:distribution).should be_valid
  end

  it "should be invalid when missing kind" do
    Factory.build(:distribution, {
      :kind => nil
    }).should_not be_valid
  end
  
  describe "should be invalid with unexpected formats" do
    it "JPG" do
      Factory.build(:distribution, {
        :format => "JPG"
      }).should_not be_valid
    end

    it "TIFF" do
      Factory.build(:distribution, {
        :format => "TIFF"
      }).should_not be_valid
    end
  end

  describe "should be valid with non-document kind / nil format" do
    it "API / nil" do
      Factory.build(:distribution, {
        :kind   => "API",
        :format => nil
      }).should be_valid
    end

    it "tool / nil" do
      Factory.build(:distribution, {
        :kind   => "tool",
        :format => nil
      }).should be_valid
    end
  end

  describe "should be invalid with non-document kind / any non-nil format" do
    it "API / CSV" do
      Factory.build(:distribution, {
        :kind   => "API",
        :format => "CSV"
      }).should_not be_valid
    end

    it "tool / unexpected" do
      Factory.build(:distribution, {
        :kind   => "tool",
        :format => "Crazy Town"
      }).should_not be_valid
    end
  end

end
