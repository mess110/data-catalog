require 'spec_helper'

describe DataSet do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:data_set).should be_valid
    end

    it "should calculate correct ratings" do
      ds = Factory.build(:data_set)
      ds.valid?
      dat, doc, int = ds.data_quality, ds.documentation_quality, ds.interestingness
      [dat['min'], dat['max'], dat['avg']].should == [1, 5, 3.4]
      [doc['min'], doc['max'], doc['avg']].should == [1, 3, 1.75]
      [int['min'], int['max'], int['avg']].should == [3, 5, 4.0]
    end

    it "should be invalid when year is a string" do
      ds = Factory.build(:data_set, {
        :released => { 'year' => '2010' }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1
      errors[:released].length == 2
      errors[:released].should include("year (2010) must be between 1970 and 2069")
      errors[:released].should include("year must be an integer if present")
    end

    it "should be invalid when month is out of range" do
      ds = Factory.build(:data_set, {
        :released => { 'month' => 13 }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1
      errors[:released].length == 1
      errors[:released].should include("if month is given, then year must also be given")
    end

    it "should be invalid when min is not an integer" do
      ds = Factory.build(:data_set, {
        :data_quality => {
          'min'  => 1.3,
          'max'  => 1,
          'avg'  => 1,
          'bins' => [1, 0, 0, 0, 0],
        }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1
      errors[:data_quality].length == 1
      errors[:data_quality].should include("min must be an integer if present")
    end

    it "should be invalid when bins is not an array" do
      ds = Factory.build(:data_set, {
        :documentation_quality => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => 5,
        }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1
      errors[:documentation_quality].length == 1
      errors[:documentation_quality].should include("bins must be an array")
    end

    it "should be invalid when bin item is not an integer" do
      ds = Factory.build(:data_set, {
        :interestingness => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => [0, 1, 3.3, 2, 1.6],
        }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1
      errors[:interestingness].length == 2
      errors[:interestingness].should include("bins[2] must be an integer if present")
      errors[:interestingness].should include("bins[4] must be an integer if present")
    end

  end
end
