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
  
  describe "should be invalid when non-Document kind / any non-nil format" do
    it "API / CSV" do
      Factory.build(:data_representation, {
        :kind   => "API",
        :format => "CSV"
      }).should_not be_valid
    end

    it "Tool / Unexpected" do
      Factory.build(:data_representation, {
        :kind   => "API",
        :format => "Crazy Town"
      }).should_not be_valid
    end
  end

end
