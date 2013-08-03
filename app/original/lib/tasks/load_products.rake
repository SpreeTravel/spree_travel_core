
namespace :db do
  desc 'Loads data for programs'
  task :programs do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_programs')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for tours'
  task :tours do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_tours')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for accommodations'
  task :accommodations do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_accommodations')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for transfers'
  task :transfers do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_transfers')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for rents'
  task :rents do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_rents')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for flights'
  task :flights do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_flights')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for destinations'
  task :destinations do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_destinations')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads data for images'
  task :images do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_images')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Loads points of interest and locations'
  task :points do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'load_points')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

  desc 'Delete all products and related data'
  task :delete_products do
    Spree::Product.delete_all
    Spree::Variant.delete_all
    Spree::Relation.delete_all
    Spree::ProductProperty.delete_all
    #ActiveRecord::Base.connection.execute 'delete from spree_product_taxons;'
    #ActiveRecord::Base.connection.execute 'delete from spree_option_values_variants'
    #ActiveRecord::Base.connection.execute 'delete from spree_product_options_types'

  end

  desc 'Fix data'
  task :fix do
    sample_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'fix_data')

    Rake::Task['db:load_dir'].reenable
    Rake::Task['db:load_dir'].invoke(sample_path)
  end

end

namespace :db do
  desc 'Load data for all products'
  #task :products => ['db:programs', 'db:tours', 'db:accommodations', 'db:flights', 'db:rents',  'db:transfers', 'db:destinations', 'db:points', 'db:images']
  task :products => ['db:accommodations', 'db:programs', 'db:tours', 'db:flights', 'db:rents', 'db:destinations', 'db:points', 'db:transfers']
end
