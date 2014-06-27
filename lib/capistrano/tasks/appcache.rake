namespace :deploy do
  task :create_appcache do
    on roles(:app) do
      within release_path do
        rake 'appcache'
      end
    end
  end
end
