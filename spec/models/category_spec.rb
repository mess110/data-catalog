require 'spec_helper'

describe Category do
  describe "unsaved" do
    subject { Factory.build(:category) }

    it "should be valid" do
      subject.should be_valid
    end

    it "should be primary" do
      subject.primary.should be_true
      subject.primary?.should be_true
    end
  end

  describe "unsaved, validated" do
    subject { Factory.build(:category).tap { :valid? } }

    it "should be primary" do
      subject.primary.should be_true
    end
  end

  describe "saved" do
    subject { Factory.create(:category) }

    it "should be primary" do
      subject.primary.should be_true
      subject.primary?.should be_true
    end

    it "should have no parents" do
      subject.parent.should be_nil
    end

    it "should have no children" do
      subject.children.should be_empty
    end
  end

  describe "saved parent and child" do
    before do
      @parent = Factory.create(:category)
      @child = Category.create!(
        :uid    => 'criminal-justice',
        :name   => 'Criminal Justice',
        :parent => @parent
      )
    end

    it "parent should be primary" do
      @parent.primary.should be_true
      @parent.primary?.should be_true
    end

    it "child should be secondary" do
      @child.primary.should be_false
      @child.primary?.should be_false
    end

    it "parent should be discoverable via primary scope" do
      Category.primary.all.should == [@parent]
    end

    it "child should be discoverable via secondary scope" do
      Category.secondary.all.should == [@child]
    end
  end
end
