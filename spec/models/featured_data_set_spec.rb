require 'spec_helper'

describe FeaturedDataSet do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:featured_data_set).should be_valid
    end

    it "should be invalid when missing start_at" do
      f = Factory.build(:featured_data_set, { :start_at => nil })
      f.should_not be_valid
    end

    it "should be invalid when missing data_set" do
      f = Factory.build(:featured_data_set, { :data_set => nil })
      f.should_not be_valid
    end

    it "should be invalid when stop_at < start_at" do
      f = Factory.build(:featured_data_set)
      f.stop_at = f.start_at - 15
      f.should_not be_valid
      errors = f.errors
      errors.length.should == 1
      errors[:stop_at].should include("must be later than start_at")
    end
  end

  # describe "Associations" do
  # end
end
