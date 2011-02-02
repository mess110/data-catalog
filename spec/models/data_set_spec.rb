require 'spec_helper'

describe DataSet do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:data_set).should be_valid
    end

    it "should calculate correct data_quality ratings" do
      ds = Factory.build(:data_set)
      ds.valid?
      ds.data_quality.should == {
        'min'  => 1,
        'max'  => 5,
        'avg'  => 3.4,
        'bins' => [4, 0, 0, 0, 6],
        'n'    => 10,
      }
    end

    it "should calculate correct documentation quality ratings" do
      ds = Factory.build(:data_set)
      ds.valid?
      ds.documentation_quality.should == {
        'min'  => 1,
        'max'  => 3,
        'avg'  => 1.75,
        'bins' => [4, 2, 2, 0, 0],
        'n'    => 8,
      }
    end

    it "should calculate correct interestingness ratings" do
      ds = Factory.build(:data_set)
      ds.valid?
      ds.interestingness.should == {
        'min'  => 3,
        'max'  => 5,
        'avg'  => 4.0,
        'bins' => [0, 0, 4, 4, 4],
        'n'    => 12,
      }
    end

    it "should be invalid when year is a string" do
      ds = Factory.build(:data_set, {
        :released => { 'year' => '2010' }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1 &&
        errors[:released].length == 1
      errors[:released].should include("year must be an integer if present")
    end

    it "should be invalid when month is out of range" do
      ds = Factory.build(:data_set, {
        :released => { 'month' => 13 }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1 &&
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
      errors.length.should == 1 &&
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
      errors.length.should == 1 &&
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
      errors.length.should == 1 &&
        errors[:interestingness].length == 2
      errors[:interestingness].should include("bins[2] must be an integer if present")
      errors[:interestingness].should include("bins[4] must be an integer if present")
    end

    it "should allow n item to be passed in but recalculate it" do
      ds = Factory.build(:data_set, {
        :interestingness => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => [0, 1, 3, 2, 1],
          'n'    => 1823
        }
      })
      ds.should be_valid
      ds.valid?
      ds.interestingness['n'].should == 7
    end

    it "should be invalid when n item is not an integer" do
      ds = Factory.build(:data_set, {
        :interestingness => {
          'min'  => nil,
          'max'  => nil,
          'avg'  => nil,
          'bins' => [0, 1, 3, 2, 1],
          'n'    => "4"
        }
      })
      ds.should_not be_valid
      errors = ds.errors
      errors.length.should == 1 &&
        errors[:interestingness].length == 1
      errors[:interestingness].should include("n must be an integer if present")
    end
  end

  describe "saved" do
    before do
      @factory = Factory.create(:data_set)
    end

    it "should populate keywords" do
      @factory.keywords.should == %w(fema public assistance funded projects
        detail through pa program cdfa number 97.036 provides supplemental
        federal disaster grant debris removal emergency protective measures
        repair replacement restoration disaster-damaged publicly owned
        facilities certain private non-profit pnp organizations also
        encourages protection these damaged future events providing hazard
        mitigation during recovery process dataset lists all recipients
        designated applicants features list every individual project called
        worksheets)
    end
  end

  describe "with embedded Distribution" do
    before do
      @distributions_params = [
        {
          "url"    => "http://www.data.gov/download/329/csv",
          "kind"   => "document",
          "format" => "CSV"
        },
        {
          "url"    => "http://www.data.gov/download/330/csv",
          "kind"   => "document",
          "format" => "CSV"
        }
      ]
    end

    describe "unsaved" do
      before do
        @data_set = Factory.build(:data_set)
      end

      # TODO: use a shared example group
      it "=" do
        distributions = @distributions_params.map do |params|
          Distribution.new(params)
        end
        @data_set.distributions = distributions
        @data_set.distributions.length.should == 2
      end

      # TODO: use a shared example group
      it "<<" do
        @distributions_params.each do |params|
          @data_set.distributions << Distribution.new(params)
        end
        @data_set.distributions.length.should == 2
      end
    end

    describe "saved" do
      before do
        @data_set = Factory.create(:data_set)
      end

      # TODO: use a shared example group
      it "=" do
        distributions = @distributions_params.map do |params|
          Distribution.new(params)
        end
        @data_set.distributions = distributions
        @data_set.distributions.length.should == 2
      end

      # TODO: use a shared example group
      it "<<" do
        @distributions_params.each do |params|
          @data_set.distributions << Distribution.new(params)
        end
        @data_set.distributions.length.should == 2
      end
    end
  end
end
