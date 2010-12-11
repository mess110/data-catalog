require 'spec_helper'

describe Activity do

  it "sign-up" do
    Factory.build(:sign_up_activity).should be_valid
  end

  it "follow" do
    Factory.build(:follow_activity).should be_valid
  end

  it "watch" do
    Factory.build(:watch_activity).should be_valid
  end

  it "comment" do
    Factory.build(:comment_activity).should be_valid
  end

  it "suggest" do
    Factory.build(:suggest_activity).should be_valid
  end

  it "related object associations with a sign-up activity" do
    @activity = Factory.create(:sign_up_activity)
    subject_user = @activity.subject_user
    subject_user.activities_as_subject.to_a.should == [@activity]
    subject_user.activities_as_object.to_a.should == []
  end

  it "related object associations with a follow activity" do
    @activity = Factory.create(:follow_activity)
    subject_user = @activity.subject_user
    subject_user.activities_as_subject.to_a.should == [@activity]
    subject_user.activities_as_object.to_a.should == []
    object_user = @activity.object_user
    object_user.activities_as_subject.to_a.should == []
    object_user.activities_as_object.to_a.should == [@activity]
  end

  it "related object associations with a comment activity" do
    @activity = Factory.create(:comment_activity)
    subject_user = @activity.subject_user
    subject_user.activities_as_subject.to_a.should == [@activity]
    subject_user.activities_as_object.to_a.should == []
    object_data_source = @activity.object_data_source
    object_data_source.activities_as_object.to_a.should == [@activity]
  end

end
