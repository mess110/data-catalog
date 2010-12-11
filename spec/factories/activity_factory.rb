Factory.define :activity do |a|
  a.subject_label 'David James'
  a.subject_path '/users/david-james'
  a.association :subject_user, :factory => :user
end

Factory.define :sign_up_activity, :parent => :activity do |a|
  a.verb 'sign-up'
end

Factory.define :follow_activity, :parent => :activity do |a|
  a.verb 'follow'
  a.object_label 'Jerry Hausman'
  a.object_path '/users/jerry-hausman'
  a.association :object_user, :factory => :user_2
end

Factory.define :watch_activity, :parent => :activity do |a|
  a.verb 'watch'
  a.object_label 'FEMA Public Assistance Funded Projects Detail'
  a.object_path 'data_sources/fema-public-assistance-funded-projects-detail'
  a.association :object_data_source, :factory => :data_source
end

Factory.define :comment_activity, :parent => :activity do |a|
  a.verb 'comment'
  a.object_label 'FEMA Public Assistance Funded Projects Detail'
  a.object_path 'data_sources/fema-public-assistance-funded-projects-detail'
  a.association :object_data_source, :factory => :data_source
end

Factory.define :suggest_activity, :parent => :activity do |a|
  a.verb 'suggest'
  a.object_label 'FEMA Public Assistance Funded Projects Detail'
  a.object_path 'data_sources/fema-public-assistance-funded-projects-detail'
  a.association :object_data_source, :factory => :data_source
end
