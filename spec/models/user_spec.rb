require 'spec_helper'

describe User do
  describe "Fields" do
    it "should be valid" do
      Factory.build(:user).should be_valid
    end

    it "should be invalid when missing name" do
      Factory.build(:user, { :name => nil }).should_not be_valid
    end

    it "should be invalid when missing uid" do
      Factory.build(:user, { :uid => nil }).should_not be_valid
    end
  end
  
  describe "Associations" do
    before do
      @user = Factory.create(:user)
    end

    it "no owned or curated catalogs" do
      @user.curated_catalogs.to_a.should == [] &&
        @user.owned_catalogs.to_a.should == []
    end

    it "with curated catalog" do
      @catalog = Factory.create(:catalog)
      @catalog.curators = [@user]
      @user.curated_catalogs.to_a.should == [@catalog] &&
        @user.owned_catalogs.to_a.should == []
    end

    it "with owned catalog" do
      @catalog = Factory.create(:catalog)
      @catalog.owners = [@user]
      @user.curated_catalogs.to_a.should == [] &&
        @user.owned_catalogs.to_a.should == [@catalog]
    end
  end
end
