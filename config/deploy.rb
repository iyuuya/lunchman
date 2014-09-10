# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'lunchman'
set :repo_url, 'https://github.com/dnond/lunchman.git'
set :branch, 'deploy'
set :rbenv_ruby, '2.1.2'

set :deploy_to, '/var/www/app/lunchman'
set :scm, :git

set :linked_dirs, %w{log tmp/pids tmp/cache vendor/bundle public/system}
set :linked_files, %w{.env}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart
end
