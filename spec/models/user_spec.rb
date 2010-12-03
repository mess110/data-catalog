require 'spec_helper'

describe User do
  # describe "Fields" do
  # end
  
  describe "Associations" do
    before do
      @user = Factory.create(:user)
    end

    it "no owned or curated catalogs" do
      @user.curated_catalogs.to_a.should == []
      @user.owned_catalogs.to_a.should == []
    end

    it "with curated catalog" do
      @catalog = Factory.create(:catalog)
      @catalog.curators = [@user]
      @user.curated_catalogs.to_a.should == [@catalog]
      @user.owned_catalogs.to_a.should == []
    end

    it "with owned catalog" do
      @catalog = Factory.create(:catalog)
      @catalog.owners = [@user]
      @user.curated_catalogs.to_a.should == []
      @user.owned_catalogs.to_a.should == [@catalog]
    end
  end
end
