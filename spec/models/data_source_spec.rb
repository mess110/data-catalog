require 'spec_helper'

describe DataSource do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:data_source).should be_valid
    end

    it "should calculate correct ratings" do
      ds = Factory.build(:data_source)
      ds.valid?
      ds.data_quality['min'].should == 1
      ds.data_quality['max'].should == 5
      ds.data_quality['avg'].should == 3.4
      ds.documentation_quality['min'].should == 1
      ds.documentation_quality['max'].should == 3
      ds.documentation_quality['avg'].should == 1.75
      ds.interestingness['min'].should == 3
      ds.interestingness['max'].should == 5
      ds.interestingness['avg'].should == 4.0
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

    it "should be invalid when min is not an integer" do
      factory = Factory.build(:data_source, {
        :data_quality => {
          'min'  => 1.3,
          'max'  => 1,
          'avg'  => 1,
          'bins' => [1, 0, 0, 0, 0],
        }
      })
      factory.should_not be_valid
      errors = factory.errors
      errors.length.should == 1
      errors[:data_quality].length == 1
      errors[:data_quality].should include("min must be an integer if present")
    end

    it "should be invalid when bins is not an array" do
      factory = Factory.build(:data_source, {
        :documentation_quality => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => 5,
        }
      })
      factory.should_not be_valid
      errors = factory.errors
      errors.length.should == 1
      errors[:documentation_quality].length == 1
      errors[:documentation_quality].should include("bins must be an array")
    end

    it "should be invalid when bin item is not an integer" do
      factory = Factory.build(:data_source, {
        :interestingness => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => [0, 1, 3.3, 2, 1.6],
        }
      })
      factory.should_not be_valid
      errors = factory.errors
      errors.length.should == 1
      errors[:interestingness].length == 2
      errors[:interestingness].should include("bins[2] must be an integer if present")
      errors[:interestingness].should include("bins[4] must be an integer if present")
    end

  end
end
