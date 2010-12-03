require 'spec_helper'

describe Catalog do
  # describe "Fields" do
  # end
  
  describe "Associations" do
    before do
      @catalog = Factory.create(:catalog)
    end

    it "no owners or curators" do
      @catalog.curators.to_a.should == []
      @catalog.owners.to_a.should == []
    end

    it "with curator" do
      @user = Factory.create(:user)
      @user.curated_catalogs = [@catalog]
      @catalog.curators.to_a.should == [@user]
      @catalog.owners.to_a.should == []
    end

    it "with owner" do
      @user = Factory.create(:user)
      @user.owned_catalogs = [@catalog]
      @catalog.curators.to_a.should == []
      @catalog.owners.to_a.should == [@user]
    end
  end
end
