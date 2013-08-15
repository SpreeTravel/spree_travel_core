require 'ffaker'

#require 'rubygems'

#require 'spreadsheet'
I18n.locale = :en


#namespace :db do
#  desc 'Loads data sice db/load_data_core'
#  task :load_data_core do
#    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data/core')
#
#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(sample_path)
#  end
#end

namespace :db do
  desc 'Loads data sice db/load_data'

  task :load_data do
#    option_types_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'option_types')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(option_types_path)
    
#    option_values_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'option_values')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(option_values_path)
        
#    property_types_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'property_types')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(property_types_path)
    
#    properties_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'properties')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(properties_path)
    
#    taxonomies_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'taxonomies')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(taxonomies_path)
    
#    taxons_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'taxons')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(taxons_path)
    
#    home_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'home')

#    Rake::Task['db:load_dir'].reenable
#    Rake::Task['db:load_dir'].invoke(home_path)
    
    code_ota_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_data', 'code_ota')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(code_ota_path)

  end
end
