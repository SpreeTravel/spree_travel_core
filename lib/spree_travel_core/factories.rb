FactoryBot.define do
  GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

  p "#{Dir[File.join(GEM_ROOT, 'spec', 'factories', '**', '*.rb')]}"

  Dir[File.join(GEM_ROOT, 'spec', 'factories', '**', '*.rb')].each do |factory|
    require(factory)
  end

  # Dir["#{File.dirname(__FILE__)}/factories/**"].each do |f|
  #   require File.expand_path(f)
  # end

end
