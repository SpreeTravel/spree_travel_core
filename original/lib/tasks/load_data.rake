require 'ffaker'

namespace :db do
  desc 'Loads data sice db/load_data'
  task :load_data do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end
end
