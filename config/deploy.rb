# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'aurora_web'
set :repo_url, 'git@github.com:project-yoru/aurora-web.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/deploy/aurora_web'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# puma
# set :puma_user, fetch(:user)
# set :puma_rackup, -> { File.join(current_path, 'config.ru') }
# set :puma_state, "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
# set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
# set :puma_conf, "#{shared_path}/puma.rb"
# set :puma_access_log, "#{shared_path}/log/puma_access.log"
# set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :web
# set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
# set :puma_threads, [0, 16]
set :puma_workers, 2
# set :puma_worker_timeout, nil
# set :puma_init_active_record, false
# set :puma_preload_app, false
# set :nginx_use_ssl, false

# sidekiq
# :sidekiq_default_hooks =>  true
# :sidekiq_pid =>  File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
# :sidekiq_env =>  fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
# :sidekiq_log =>  File.join(shared_path, 'log', 'sidekiq.log')
# :sidekiq_options =>  nil
# :sidekiq_require => nil
# :sidekiq_tag => nil
# :sidekiq_config => nil
# :sidekiq_queue => nil
# :sidekiq_timeout =>  10
set :sidekiq_role, :web
# :sidekiq_processes =>  1
# :sidekiq_concurrency => nil

# namespace :deploy do

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end
