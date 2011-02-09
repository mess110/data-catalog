Factory.sequence :uid_sequence do |n|
  "factory-organization-#{n}" 
end

Factory.define :organization, :class => Organization do |o|
  o.uid Factory.next(:uid_sequence)
  o.name 'Factory Organization'
end

Factory.define :organization_with_details, :parent => :organization do |o|
  o.url "http://sunlightlabs.com/"
  o.acronym "SLL"
  o.description "We're a community of open source developers and designers dedicated to opening up our government to make it more transparent, accountable and responsible. We need your help."
end
