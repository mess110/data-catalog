set :environment, (ENV['target'] || 'staging')
set :application, 'data-catalog'
set :repository,  'git@github.com:sunlightlabs/data-catalog.git'
set :user,        'datcat2'
set :use_sudo,    false
set :scm,         :git
set :deploy_via,  :remote_cache
set :deploy_to,   "/projects/#{user}/src/#{application}"

case environment
when 'production'
  set :domain, 'v2.nationaldatacatalog.com'
  set :branch, 'production'
when 'staging'
  set :domain, 'staging.v2.nationaldatacatalog.com'
  set :branch, 'staging'
else
  raise "Invalid environment: #{environment}"
end

role :web, domain
role :app, domain
role :db,  domain, :primary => true

require 'bundler/capistrano'

namespace :deploy do
  task :migrate do
    # Do nothing (Mongo does not need to migrate)
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "killall -HUP unicorn_rails"
  end

  task :symlink_config do
    shared_config = File.join(shared_path, 'config')
    release_config = "#{release_path}/config"
    %w{analytics.yml mongoid.yml unicorn.rb}.each do |file|
      run "ln -s #{shared_config}/#{file} #{release_config}/#{file}"
    end
  end

  task :symlink_query_cache do
    shared = File.join(shared_path, 'tmp/query_cache')
    release = "#{release_path}/tmp/query_cache"
    run "ln -s #{shared} #{release}"
  end

  # background processing
  task :restart_resque do
    # TODO: clear queue?
    run "cd #{current_path}; RAILS_ENV=production QUEUE=* rake resque:work"
  end

  # TODO
  # rake resque:scheduler

end

after 'deploy:update_code' do
  deploy.symlink_config
  deploy.symlink_query_cache
end

before 'deploy:restart' do
  deploy.restart_resque
end
