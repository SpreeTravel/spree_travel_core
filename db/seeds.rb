# Loads seed data out of default dir
default_path = File.join(File.dirname(__FILE__), 'default')

Rake::Task['spree_travel_core:load'].reenable
Rake::Task['spree_travel_core:load'].invoke(default_path)
