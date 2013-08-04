require 'ffaker'

namespace :db do
  desc 'Loads data sice db/read_data'
  task :read_data do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'read_data')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end
end
