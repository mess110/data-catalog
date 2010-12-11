require 'spec_helper'

describe FeaturedDataSource do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:featured_data_source).should be_valid
    end

    it "should be invalid when missing start_at" do
      f = Factory.build(:featured_data_source, { :start_at => nil })
      f.should_not be_valid
    end

    it "should be invalid when missing data_source" do
      f = Factory.build(:featured_data_source, { :data_source => nil })
      f.should_not be_valid
    end

    it "should be invalid when stop_at < start_at" do
      f = Factory.build(:featured_data_source)
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
