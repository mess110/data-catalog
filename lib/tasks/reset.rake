namespace :db do
  desc "Drop database and create indexes"
  task :reset => ['db:drop', 'db:mongoid:create_indexes']
end

