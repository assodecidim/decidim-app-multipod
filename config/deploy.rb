# frozen_string_literal: true

lock "~> 3.20.1"

set :application, "decidim-multipod"
set :repo_url, "https://github.com/assodecidim/decidim-app-osp.git"
set :branch, :develop
set :deploy_to, "/home/app-decidim_multipod/app"
set :assets_manifests, nil

set :nvm_type, :user
set :nvm_node, "v22.14.0"
set :nvm_map_bins, %w(node npm yarn rake)

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads", "storage", "node_modules"

after "deploy:finishing", "restart_sidekiq"

task :restart_sidekiq do
  on roles(:app), in: :sequence, wait: 5 do
    execute "sudo systemctl restart sidekiq"
  end
end

Rake::Task["deploy:assets:backup_manifest"].clear_actions
