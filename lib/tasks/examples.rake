namespace :db do
  desc "Load examples from db/examples/*.yml"
  task :seed_examples => :environment do
    Examples.load
  end

  desc 'Drop database and load examples from db/examples/*.yml'
  task :reseed_examples => [:drop, :seed, :seed_examples]
end
