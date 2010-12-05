require 'spec_helper'

describe DataRepresentation do
  it "should be saveable because it must be embedded" do
    lambda {
      Factory.create(:data_representation)
    }.should raise_error(Mongoid::Errors::InvalidCollection)
  end

  it "should be valid" do
    Factory.build(:data_representation).should be_valid
  end

  it "should be invalid when missing kind" do
    Factory.build(:data_representation, {
      :kind => nil
    }).should_not be_valid
  end
  
  describe "should be invalid with unexpected formats" do
    it "JPG" do
      Factory.build(:data_representation, {
        :format => "JPG"
      }).should_not be_valid
    end

    it "TIFF" do
      Factory.build(:data_representation, {
        :format => "TIFF"
      }).should_not be_valid
    end
  end

  describe "should be valid with non-document kind / nil format" do
    it "API / nil" do
      Factory.build(:data_representation, {
        :kind   => "API",
        :format => nil
      }).should be_valid
    end

    it "tool / nil" do
      Factory.build(:data_representation, {
        :kind   => "tool",
        :format => nil
      }).should be_valid
    end
  end

  describe "should be invalid with non-document kind / any non-nil format" do
    it "API / CSV" do
      Factory.build(:data_representation, {
        :kind   => "API",
        :format => "CSV"
      }).should_not be_valid
    end

    it "tool / unexpected" do
      Factory.build(:data_representation, {
        :kind   => "tool",
        :format => "Crazy Town"
      }).should_not be_valid
    end
  end

end
