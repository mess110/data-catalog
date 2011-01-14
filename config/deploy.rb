set :environment,    ENV['target']
set :application,    'data-catalog'
set :repository,     'git@github.com:sunlightlabs/data-catalog.git'
set :user,           'datcat2'
set :use_sudo,       false
set :scm,            :git
set :deploy_via,     :remote_cache
set :deploy_to,      "/projects/#{user}/src/#{application}"
set :unicorn_binary, "unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid,    "#{current_path}/tmp/pids/unicorn.pid"

case environment
when 'production'
  set :domain,    'v2.nationaldatacatalog.com'
  set :branch,    'production'
  set :rails_env, 'production'
when 'staging'
  set :domain,    'staging.v2.nationaldatacatalog.com'
  set :branch,    'staging'
  set :rails_env, 'production'
else
  raise "Invalid environment: #{environment}"
end

role :web, domain
role :app, domain
role :db,  domain, :primary => true

require 'bundler/capistrano'

namespace :deploy do

  # == unicorn tasks: based upon: http://gist.github.com/393178 ==

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  # == database tasks ==

  task :migrate do
    # Do nothing (Mongo does not need to migrate)
  end

  task :create_mongo_indexes do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:mongoid:create_indexes"
  end

  # == symlinks tasks ==

  task :symlink_config do
    shared_config = File.join(shared_path, 'config')
    release_config = "#{release_path}/config"
    %w{analytics.yml mail.yml mongoid.yml unicorn.rb}.each do |file|
      run "ln -s #{shared_config}/#{file} #{release_config}/#{file}"
    end
  end

  task :symlink_query_cache do
    shared_query_cache = File.join(shared_path, 'query_cache')
    release_query_cache = "#{release_path}/tmp/query_cache"
    run "ln -s #{shared_query_cache} #{release_query_cache}"
  end

  # == resque tasks ==

  task :restart_resque do
    stop_resque
    start_resque
  end

  task :stop_resque do
    # TODO
  end

  task :start_resque do
    # TODO: clear queue?
    run "cd #{current_path} && RAILS_ENV=#{rails_env} QUEUE=* rake resque:work"
  end

  # == resque scheduler tasks ==

  task :restart_resque_scheduler do
    stop_resque_scheduler
    start_resque_scheduler
  end

  task :stop_resque_scheduler do
    # TODO
  end

  task :start_resque_scheduler do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} QUEUE=* rake resque:work"
  end

end

# == hooks ==

after 'deploy:update' do
  deploy.symlink_config
  deploy.symlink_query_cache
  deploy.create_mongo_indexes
end

# before 'deploy:restart' do
#   deploy.restart_resque
#   deploy.restart_resque_scheduler
# end

after 'deploy:setup' do
  run 'mkdir -p ' + File.join(shared_path, 'config')
  run 'mkdir -p ' + File.join(shared_path, 'query_cache')
end
