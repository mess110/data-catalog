require 'spec_helper'

describe DataSource do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:data_source).should be_valid
    end

    it "should be invalid when year is a string" do
      factory = Factory.build(:data_source, {
        :released => { 'year' => '2010' }
      })
      factory.should_not be_valid
      errors = factory.errors
      errors.length.should == 1
      errors[:released].length == 2
      errors[:released].should include("year (2010) must be between 1970 and 2069")
      errors[:released].should include("year must be an integer if present")
    end

    it "should be invalid when month is out of range" do
      factory = Factory.build(:data_source, {
        :released => { 'month' => 13 }
      })
      factory.should_not be_valid
      errors = factory.errors
      errors.length.should == 1
      errors[:released].length == 1
      errors[:released].should include("if month is given, then year must also be given")
    end

  end
end
