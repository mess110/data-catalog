require 'spec_helper'

describe Activity do

  describe "sign-up" do
    it "build" do
      Factory.build(:sign_up_activity).should be_valid
    end

    describe "create" do
      before do
        @activity = Factory.create(:sign_up_activity)
        @subject_user = @activity.subject_user
      end

      it "subject_user.activities_as_subject" do
        @subject_user.activities_as_subject.to_a.should == [@activity]
      end

      it "subject_user.activities_as_object" do
        @subject_user.activities_as_object.to_a.should == []
      end
    end
  end

  describe "follow" do
    it "build" do
      Factory.build(:follow_activity).should be_valid
    end

    describe "create" do
      before do
        @activity = Factory.create(:follow_activity)
        @subject_user = @activity.subject_user
        @object_user = @activity.object_user
      end

      it "subject_user.activities_as_subject" do
        @subject_user.activities_as_subject.to_a.should == [@activity]
      end

      it "subject_user.activities_as_object" do
        @subject_user.activities_as_object.to_a.should == []
      end

      it "object_user.activities_as_subject" do
        @object_user.activities_as_subject.to_a.should == []
      end

      it "object_user.activities_as_object" do
        @object_user.activities_as_object.to_a.should == [@activity]
      end
    end
  end

  describe "comment" do
    it "build" do
      Factory.build(:comment_activity).should be_valid
    end

    describe "create" do
      before do
        @activity = Factory.create(:comment_activity)
        @subject_user = @activity.subject_user
        @object_data_set = @activity.object_data_set
      end

      it "subject_user activities_as_subject" do
        @subject_user.activities_as_subject.to_a.should == [@activity]
      end

      it "subject_user activities_as_object" do
        @subject_user.activities_as_object.to_a.should == []
      end

      it "object_data_set activities_as_object" do
        @object_data_set.activities_as_object.to_a.should == [@activity]
      end
    end
  end

  describe "watch" do
    it "build" do
      Factory.build(:watch_activity).should be_valid
    end
  end

  describe "suggest" do
    it "build" do
      Factory.build(:suggest_activity).should be_valid
    end
  end

end
