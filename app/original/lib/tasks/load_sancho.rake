#!/usr/bin/ruby

#####################################################
# VARIABLES
#####################################################

#####################################################
# FUNCIONES
#####################################################

#####################################################
# TAREAS
#####################################################

namespace :db do
  desc 'Para cargar las cosas que hace sancho'
  task :sancho => ['db:bootstrap', 'db:migrate:redo', 'solr:reindex', 'db:remove_slides']

  desc 'Para eliminar los slides esos pesados'
  task 'remove_slides' do
  end
end


