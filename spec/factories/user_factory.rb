Factory.define :user do |u|
  u.uid 'david-james'
  u.name 'David James'
  u.email 'djames@fake-345-domain.com'
  u.password '098765'
end

Factory.define :user_2, :class => User do |u|
  u.uid 'jerry-hausman'
  u.name 'Jerry Hausman'
  u.email 'jhauseman@fake-345-domain.com'
  u.password '098765'
end
